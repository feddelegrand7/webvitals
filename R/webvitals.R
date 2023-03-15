webvitals_deps <- function() {
  htmltools::htmlDependency(
    name = "web-vitals.iife",
    version = "3.3.0",
    src = c(file = "js"),
    script = "web-vitals.iife.js",
    package = "webvitals"
  )
}

check_for_input <- function(x) {

  if (length(x) > 1) {
    stop("input length must be equal to 1")
  }

  if (is.na(x)) {
    stop("input is NA, please provide a value")
  }

  if (is.null(x)) {
    stop("input is NULL, please provide a value")
  }

}

#' Console log and query the CLS, FID and LCP using the web-vitals JS library
#'
#' @param FID_id the ID of the FID value that will be collected
#' @param LCP_id the ID of the LCP value that will be collected
#' @param CLS_id the ID of the CLS value that will be collected
#' @param wait_to_get_info how long (in milliseconds) do you want to wait before collecting the web-vitals metrics. Defaults to 6000ms
#'
#' @return called for the side effect of using the web-vitals JS library.
#' @export
#'

implement_webvitals <- function(FID_id, LCP_id, CLS_id, wait_to_get_info = 60000) {

  check_for_input(x = FID_id)
  check_for_input(x = LCP_id)
  check_for_input(x = CLS_id)
  check_for_input(x = wait_to_get_info)

  el <- htmltools::tagList(
    webvitals_deps(),

    htmltools::tags$script(htmltools::HTML(
      glue::glue(
        "
    let webvitals_r_console_storage_FID = [];
    let webvitals_r_console_storage_LCP = [];
    let webvitals_r_console_storage_CLS = [];

    console_log_webvitals_r_FID = function(msg) {
      webvitals_r_console_storage_FID.push(msg);
      console.log(msg);
    };

    console_log_webvitals_r_LCP = function(msg) {
      webvitals_r_console_storage_LCP.push(msg);
      console.log(msg);
    };

    console_log_webvitals_r_CLS = function(msg) {
      webvitals_r_console_storage_CLS.push(msg);
      console.log(msg);
    };

    webVitals.onFID(console_log_webvitals_r_FID);
    webVitals.onLCP(console_log_webvitals_r_LCP);
    webVitals.onCLS(console_log_webvitals_r_CLS);

    set_shinyInput_webvitals = function(FID_storage, LCP_storage, CLS_storage) {

      idx_FID = FID_storage.length - 1;
      idx_LCP = LCP_storage.length - 1;
      idx_CLS = CLS_storage.length - 1;

      Shiny.setInputValue('<<<<FID_id>>>>', FID_storage[idx_FID]);
      Shiny.setInputValue('<<<<LCP_id>>>>', LCP_storage[idx_LCP]);
      Shiny.setInputValue('<<<<CLS_id>>>>', CLS_storage[idx_CLS]);

    console.log('function is being run');
  };

  setTimeout(set_shinyInput_webvitals, <<<<wait_to_get_info>>>>, webvitals_r_console_storage_FID, webvitals_r_console_storage_LCP, webvitals_r_console_storage_CLS);

      ",

      .open = "<<<<",
      .close = ">>>>"

      )
    ))

  )

  htmltools::tagAppendChild(
    tag = htmltools::tags$head(),
    child = el
  )
}
