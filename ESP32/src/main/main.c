/* Ejemplo configurador maquina*/

#include <sys/param.h>

#include "esp_event.h"
#include "esp_log.h"
#include "esp_mac.h"

#include "nvs.h"
#include "nvs_flash.h"
#include "esp_wifi.h"
#include "esp_netif.h"
#include "lwip/inet.h"

#include "esp_http_server.h"
#include "dns_server.h"

#include "driver/gpio.h"

#define EXAMPLE_ESP_WIFI_SSID CONFIG_ESP_WIFI_SSID
#define EXAMPLE_ESP_WIFI_PASS CONFIG_ESP_WIFI_PASSWORD
#define EXAMPLE_MAX_STA_CONN CONFIG_ESP_MAX_STA_CONN
#define NCONFIGS 3

typedef struct {
    char key[16];
    int32_t val;
} pin_config_T;

const pin_config_T defaults[] = {
    {"pin_13", 0},
    {"pin_12", 0},
    {"pin_14", 1}
};

void aplicar_configuraciones_guardadas(const pin_config_T *defaults, int cantidad);
void verificar_defaults(const pin_config_T *defaults, int cantidad);
void guardar_estado_gpio(int pin, int value);

extern const char root_start[] asm("_binary_root_html_start");
extern const char root_end[] asm("_binary_root_html_end");

static const char *TAG = "example";

static void wifi_event_handler(void *arg, esp_event_base_t event_base,
                               int32_t event_id, void *event_data){
    if (event_id == WIFI_EVENT_AP_STACONNECTED) {
        wifi_event_ap_staconnected_t *event = (wifi_event_ap_staconnected_t *)event_data;
        ESP_LOGI(TAG, "station " MACSTR " join, AID=%d",
                 MAC2STR(event->mac), event->aid);
    } else if (event_id == WIFI_EVENT_AP_STADISCONNECTED) {
        wifi_event_ap_stadisconnected_t *event = (wifi_event_ap_stadisconnected_t *)event_data;
        ESP_LOGI(TAG, "station " MACSTR " leave, AID=%d, reason=%d",
                 MAC2STR(event->mac), event->aid, event->reason);
    }
}

static void wifi_init_softap(void){
    wifi_init_config_t cfg = WIFI_INIT_CONFIG_DEFAULT();
    ESP_ERROR_CHECK(esp_wifi_init(&cfg));

    ESP_ERROR_CHECK(esp_event_handler_register(WIFI_EVENT, ESP_EVENT_ANY_ID, &wifi_event_handler, NULL));

    wifi_config_t wifi_config = {
        .ap = {
            .ssid = EXAMPLE_ESP_WIFI_SSID,
            .ssid_len = strlen(EXAMPLE_ESP_WIFI_SSID),
            .password = EXAMPLE_ESP_WIFI_PASS,
            .max_connection = EXAMPLE_MAX_STA_CONN,
            .authmode = WIFI_AUTH_WPA_WPA2_PSK
        },
    };
    if (strlen(EXAMPLE_ESP_WIFI_PASS) == 0) {
        wifi_config.ap.authmode = WIFI_AUTH_OPEN;
    }

    ESP_ERROR_CHECK(esp_wifi_set_mode(WIFI_MODE_AP));
    ESP_ERROR_CHECK(esp_wifi_set_config(ESP_IF_WIFI_AP, &wifi_config));
    ESP_ERROR_CHECK(esp_wifi_start());

    esp_netif_ip_info_t ip_info;
    esp_netif_get_ip_info(esp_netif_get_handle_from_ifkey("WIFI_AP_DEF"), &ip_info);

    char ip_addr[16];
    inet_ntoa_r(ip_info.ip.addr, ip_addr, 16);
    ESP_LOGI(TAG, "Set up softAP with IP: %s", ip_addr);

    ESP_LOGI(TAG, "wifi_init_softap finished. SSID:'%s' password:'%s'",
             EXAMPLE_ESP_WIFI_SSID, EXAMPLE_ESP_WIFI_PASS);
}

// HTTP GET Handler
static esp_err_t root_get_handler(httpd_req_t *req){
    const uint32_t root_len = root_end - root_start;

    ESP_LOGI(TAG, "Serve root");
    httpd_resp_set_type(req, "text/html");
    httpd_resp_send(req, root_start, root_len);

    return ESP_OK;
}
//Manejador pines
esp_err_t set_pin_handler(httpd_req_t *req){
    char buf[100];
    int ret = httpd_req_get_url_query_str(req, buf, sizeof(buf));
    if (ret == ESP_OK) {
        char param[10];
        if (httpd_query_key_value(buf, "pin", param, sizeof(param)) == ESP_OK) {
            int pin = atoi(param);
            if (httpd_query_key_value(buf, "value", param, sizeof(param)) == ESP_OK) {
                int value = atoi(param);
                gpio_set_level(pin, value);
                ESP_LOGI("set_pin", "Set GPIO %d to %d", pin, value);
            }
        }
    }
    httpd_resp_send(req, "OK", HTTPD_RESP_USE_STRLEN);
    return ESP_OK;
}
//Almacenador en memoria persistente
esp_err_t set_nvs_handler(httpd_req_t *req) {
    char buf[100];
    int ret = httpd_req_get_url_query_str(req, buf, sizeof(buf));
    if (ret != ESP_OK) {
        httpd_resp_send_500(req);
        return ESP_FAIL;
    }

    char key[16];
    char val_str[8];
    int32_t val = 0;

    if (httpd_query_key_value(buf, "key", key, sizeof(key)) == ESP_OK &&
        httpd_query_key_value(buf, "value", val_str, sizeof(val_str)) == ESP_OK) {
        val = atoi(val_str);

        nvs_handle_t handle;
        esp_err_t err = nvs_open("storage", NVS_READWRITE, &handle);
        if (err == ESP_OK) {
            nvs_set_i32(handle, key, val);
            nvs_commit(handle);
            nvs_close(handle);
            ESP_LOGI("HTTP", "Seteado en NVS: %s = %ld", key, (long)val);
            httpd_resp_sendstr(req, "OK");
            return ESP_OK;
        }
    }

    httpd_resp_send_500(req);
    return ESP_FAIL;
}
//Aplicador de config almacenada
esp_err_t aplicar_config_handler(httpd_req_t *req){
    aplicar_configuraciones_guardadas(defaults, NCONFIGS);
    httpd_resp_sendstr(req, "Configuración aplicada");
    return ESP_OK;
}

static const httpd_uri_t root = {
    .uri = "/",
    .method = HTTP_GET,
    .handler = root_get_handler
};
// HTTP Error (404) Handler - Redirects all requests to the root page
esp_err_t http_404_error_handler(httpd_req_t *req, httpd_err_code_t err){
    // Set status
    httpd_resp_set_status(req, "302 Temporary Redirect");
    // Redirect to the "/" root directory
    httpd_resp_set_hdr(req, "Location", "/");
    // iOS requires content in the response to detect a captive portal, simply redirecting is not sufficient.
    httpd_resp_send(req, "Redirect to the captive portal", HTTPD_RESP_USE_STRLEN);

    ESP_LOGI(TAG, "Redirecting to root");
    return ESP_OK;
}
//Handler para setear pines manualmente
static const httpd_uri_t set_pin_uri = {
    .uri       = "/set_pin",
    .method    = HTTP_GET,
    .handler   = set_pin_handler,
    .user_ctx  = NULL
};
//Handler para almacenar configuración
httpd_uri_t uri_set_nvs = {
    .uri = "/set_nvs",
    .method = HTTP_GET,
    .handler = set_nvs_handler,
    .user_ctx = NULL
};
//Handler para aplicar config almacenada
httpd_uri_t uri_aplicar = {
    .uri = "/aplicar_config",
    .method = HTTP_GET,
    .handler = aplicar_config_handler,
    .user_ctx = NULL
};

static httpd_handle_t start_webserver(void){
    httpd_handle_t server = NULL;
    httpd_config_t config = HTTPD_DEFAULT_CONFIG();
    config.max_open_sockets = 13;
    config.lru_purge_enable = true;

    // Start the httpd server
    ESP_LOGI(TAG, "Starting server on port: '%d'", config.server_port);
    if (httpd_start(&server, &config) == ESP_OK) {
        // Set URI handlers
        ESP_LOGI(TAG, "Registering URI handlers");
        httpd_register_uri_handler(server, &root);
        httpd_register_err_handler(server, HTTPD_404_NOT_FOUND, http_404_error_handler);
        httpd_register_uri_handler(server, &set_pin_uri);
        httpd_register_uri_handler(server, &uri_set_nvs);
        httpd_register_uri_handler(server, &uri_aplicar);
    }
    return server;
}
//Inicializo pines como salida
gpio_config_t io_conf = {
    .pin_bit_mask = (1ULL << 13) | (1ULL << 12) | (1ULL << 14),
    //.pin_bit_mask = (1ULL << 13),
    .mode = GPIO_MODE_OUTPUT,
    .pull_down_en = 0,
    .pull_up_en = 0,
    .intr_type = GPIO_INTR_DISABLE
};

void app_main(void){

    //Configuracion de los pines
    gpio_config(&io_conf);

    //Inicializo memoria permanente
    esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES || ret == ESP_ERR_NVS_NEW_VERSION_FOUND){
        ESP_ERROR_CHECK(nvs_flash_erase());
        ret = nvs_flash_init();
    }

    ESP_ERROR_CHECK(ret);

    esp_log_level_set("httpd_uri", ESP_LOG_ERROR);
    esp_log_level_set("httpd_txrx", ESP_LOG_ERROR);
    esp_log_level_set("httpd_parse", ESP_LOG_ERROR);

    // Initialize networking stack
    ESP_ERROR_CHECK(esp_netif_init());

    // Create default event loop needed by the  main app
    ESP_ERROR_CHECK(esp_event_loop_create_default());

    // Initialize Wi-Fi including netif with default config
    esp_netif_create_default_wifi_ap();

    // Initialise ESP32 in SoftAP mode
    wifi_init_softap();

    // Configure DNS-based captive portal, if configured
    #ifdef CONFIG_ESP_ENABLE_DHCP_CAPTIVEPORTAL
        dhcp_set_captiveportal_url();
    #endif

    // Start the server for the first time
    start_webserver();

    // Start the DNS server that will redirect all queries to the softAP IP
    dns_server_config_t config = DNS_SERVER_CONFIG_SINGLE("*" /* all A queries */, "WIFI_AP_DEF" /* softAP netif ID */);
    start_dns_server(&config);


    verificar_defaults(defaults, NCONFIGS);
    aplicar_configuraciones_guardadas(defaults, NCONFIGS);
}

void guardar_estado_gpio(int pin, int value){
    nvs_handle_t my_handle;
    char key[10];
    sprintf(key, "pin_%d", pin);
    esp_err_t err = nvs_open("storage", NVS_READWRITE, &my_handle);
    if (err == ESP_OK) {
        nvs_set_i32(my_handle, key, value);
        nvs_commit(my_handle);
        nvs_close(my_handle);
        ESP_LOGI("NVS", "Guardado: %s = %d", key, value);
    }
}

void verificar_defaults(const pin_config_T *defaults, int cantidad){
    nvs_handle_t handle;
    esp_err_t err = nvs_open("storage", NVS_READWRITE, &handle);
    if (err != ESP_OK) {
        ESP_LOGE("NVS", "Error al abrir NVS: %s", esp_err_to_name(err));
        return;
    }

    for (int i = 0; i < cantidad; i++) {
        int32_t dummy;
        err = nvs_get_i32(handle, defaults[i].key, &dummy);
        if (err == ESP_ERR_NVS_NOT_FOUND) {
            nvs_set_i32(handle, defaults[i].key, defaults[i].val);
            ESP_LOGI("NVS", "Seteando default: %s = %ld", defaults[i].key, (long)defaults[i].val);
        } else {
            int32_t actual = -1;
            nvs_get_i32(handle, defaults[i].key, &actual);
            ESP_LOGI("NVS", "Key %s ya existe en NVS con valor real = %ld", defaults[i].key, (long)actual);
            //ESP_LOGI("NVS", "Key %s ya existe, (%li) no se modifica", defaults[i].key, defaults[i].val);
        }
    }
    nvs_commit(handle);
    nvs_close(handle);
}
//Aplico configuración de nvm al hw. Necesito pasar defaults para saber que pines se modifican
void aplicar_configuraciones_guardadas(const pin_config_T *defaults, int cantidad){
    nvs_handle_t handle;
    esp_err_t err = nvs_open("storage", NVS_READONLY, &handle);
    if (err != ESP_OK) {
        ESP_LOGE("NVS", "No se pudo abrir NVS: %s", esp_err_to_name(err));
        return;
    }

    for (int i = 0; i < cantidad; i++) {
        int32_t val = 0;
        err = nvs_get_i32(handle, defaults[i].key, &val);
        if (err == ESP_OK) {
            // Extraer el número de pin desde el nombre de la clave "pin_13" → 13
            int pin = atoi(&defaults[i].key[4]);
            gpio_set_level(pin, val);
            ESP_LOGI("GPIO", "GPIO %d seteado a %ld", pin, (long)val);
        } else {
            ESP_LOGW("NVS", "No se encontró valor para %s", defaults[i].key);
        }
    }
    nvs_close(handle);
}

