#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "driver/mcpwm_prelude.h"
#include "driver/gpio.h"

#define OUT_PIN    18
#define CHARGE_PIN 23
#define GATE_PIN   22

void app_main(void)
{
    // ---------------- GPIO INIT ----------------
    gpio_config_t io_conf = {
        .pin_bit_mask = (1ULL << CHARGE_PIN) | (1ULL << GATE_PIN),
        .mode = GPIO_MODE_OUTPUT,
        .pull_down_en = 0,
        .pull_up_en = 0,
        .intr_type = GPIO_INTR_DISABLE
    };
    gpio_config(&io_conf);

    // start safe
    gpio_set_level(CHARGE_PIN, 0);
    gpio_set_level(GATE_PIN, 0);

    // ---------------- MCPWM SETUP (UNCHANGED) ----------------
    mcpwm_timer_handle_t timer = NULL;
    mcpwm_oper_handle_t oper = NULL;
    mcpwm_cmpr_handle_t cmp = NULL;
    mcpwm_gen_handle_t gen = NULL;

    mcpwm_timer_config_t timer_config = {
        .group_id = 0,
        .clk_src = MCPWM_TIMER_CLK_SRC_DEFAULT,
        .resolution_hz = 80 * 1000 * 1000,
        .period_ticks = 4,
        .count_mode = MCPWM_TIMER_COUNT_MODE_UP,
    };

    mcpwm_new_timer(&timer_config, &timer);

    mcpwm_operator_config_t oper_config = {
        .group_id = 0,
    };

    mcpwm_new_operator(&oper_config, &oper);
    mcpwm_operator_connect_timer(oper, timer);

    mcpwm_comparator_config_t cmp_config = {
        .flags.update_cmp_on_tez = true,
    };

    mcpwm_new_comparator(oper, &cmp_config, &cmp);
    mcpwm_comparator_set_compare_value(cmp, 2);

    mcpwm_generator_config_t gen_config = {
        .gen_gpio_num = OUT_PIN,
    };

    mcpwm_new_generator(oper, &gen_config, &gen);

    mcpwm_gen_timer_event_action_t timer_action =
        MCPWM_GEN_TIMER_EVENT_ACTION(
            MCPWM_TIMER_DIRECTION_UP,
            MCPWM_TIMER_EVENT_EMPTY,
            MCPWM_GEN_ACTION_HIGH
        );

    mcpwm_generator_set_action_on_timer_event(gen, timer_action);

    mcpwm_gen_compare_event_action_t cmp_action =
        MCPWM_GEN_COMPARE_EVENT_ACTION(
            MCPWM_TIMER_DIRECTION_UP,
            cmp,
            MCPWM_GEN_ACTION_LOW
        );

    mcpwm_generator_set_action_on_compare_event(gen, cmp_action);

    mcpwm_timer_enable(timer);
    mcpwm_timer_start_stop(timer, MCPWM_TIMER_START_NO_STOP);

    // ---------------- BURST CONTROL LOOP ----------------
    while (1)
    {
        // =========================
        // CHARGE PHASE
        // =========================
        gpio_set_level(CHARGE_PIN, 1);
        gpio_set_level(GATE_PIN, 0);
        vTaskDelay(pdMS_TO_TICKS(500));

        // =========================
        // FIRE / GATE OPEN
        // =========================
        gpio_set_level(CHARGE_PIN, 0);
        gpio_set_level(GATE_PIN, 1);
        vTaskDelay(pdMS_TO_TICKS(5));

        // =========================
        // SAFE STATE
        // =========================
        gpio_set_level(GATE_PIN, 0);
        gpio_set_level(CHARGE_PIN, 0);
        vTaskDelay(pdMS_TO_TICKS(500));
    }
}