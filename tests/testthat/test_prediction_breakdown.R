context("Check prediction_breakdown() function")

new_apartments <- apartmentsTest[1001, -1]
pb_lm <- prediction_breakdown(explainer_regr_lm, observation = new_apartments)
pb_rf <- prediction_breakdown(explainer_regr_rf, observation = new_apartments)

test_that("Output format",{
  expect_is(pb_lm, "prediction_breakdown_explainer")
})

test_that("Output format - plot",{
  expect_is(plot(pb_rf, pb_lm), "gg")
})

test_that("Default parameters agree with broken() (#39)", {
  expect_identical(
    attr(breakDown::broken(explainer_regr_lm$model, new_apartments), "baseline"),
    attr(pb_lm, "baseline")
  )

  rf_breakdown <- breakDown::broken(
    explainer_regr_rf$model, new_apartments,
    data = explainer_regr_rf$data, predict.function = explainer_regr_rf$predict_function
  )
  expect_identical(
    attr(rf_breakdown, "baseline"),
    attr(pb_rf, "baseline")
  )
})

test_that("`baseline` argument is respected when specified (#39)", {
  pb_lm_baseline_intercept <- prediction_breakdown(explainer_regr_lm, observation = new_apartments, baseline = "Intercept")
  breakdown_lm_baseline_intercept <- breakDown::broken(explainer_regr_lm$model, new_apartments, baseline = "Intercept")

  pb_rf_baseline_intercept <- prediction_breakdown(explainer_regr_rf, observation = new_apartments, baseline = "Intercept")
  breakdown_rf_baseline_intercept <- breakDown::broken(
    explainer_regr_rf$model, new_apartments,
    data = explainer_regr_rf$data, predict.function = explainer_regr_rf$predict_function,
    baseline = "Intercept"
  )

  expect_identical(
    attr(pb_lm_baseline_intercept, "baseline"),
    attr(breakdown_lm_baseline_intercept, "baseline")
  )

  expect_identical(
    attr(pb_rf_baseline_intercept, "baseline"),
    attr(breakdown_rf_baseline_intercept, "baseline")
  )
})
