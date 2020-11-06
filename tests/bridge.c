#include "tonclient_dotnet_bridge.h"

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>

#ifdef TON_WINDOWS

#include <windows.h>

#else
#include <unistd.h>
#endif

void ton_sleep(int ms) {
#ifdef TON_WINDOWS
    Sleep(ms);
#else
    usleep(ms * 1000);   // usleep takes sleep time in us (1 millionth of a second)
#endif
}

uint32_t context;
bool success;
bool completed;

char *mem_copy_str_n(const char *str, uint32_t len) {
    char *copy = malloc((len + 1) * sizeof(char));
    strncpy(copy, str, len);
    copy[len] = 0;
    return copy;
}

void test_json_callback(const char *str, uint32_t len) {
    char *json = mem_copy_str_n(str, len);
    printf("in json_callback: %s\n", json);
    if (sscanf(json, "{\"result\":%d}", &context)) {
        printf("Context ID is %d\n", context);
    } else {
        printf("ERROR returned\n");
    }
    free(json);
}

void test_response_handler(tc_response_types_t type, const char *str, uint32_t len, bool finished) {
    char *json = mem_copy_str_n(str, len);
    switch (type) {
        case tc_response_success:
            printf("request successfully returned JSON: %s; finished %d\n", json, finished);
            success = true;
            completed = true;
            break;
        case tc_response_error:
            printf("request returned error JSON: %s; finished %d\n", json, finished);
            completed = true;
            break;
        default:
            printf("request called with response type %d and custom JSON: %s; finished %d\n", type, json, finished);
            break;
    }
    free(json);
}

int main() {
    tc_bridge_create_context("{}", 2, test_json_callback);
    if (context) {
        printf("Calling client.version\n");
        tc_bridge_request(
                context,
                "client.version", strlen("client.version"),
                "", 0,
                test_response_handler);
        while (!completed) {
            printf("Sleeping for 1000ms\n");
            ton_sleep(1000);
        }
        tc_bridge_destroy_context(context);
        return success ? 0 : -1; // version wasn't retrieved
    } else {
        return -2; // context wasn't created
    }
}
