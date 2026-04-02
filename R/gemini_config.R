#' Configure Gemini API credentials
#'
#' @param api_key Gemini API key. Defaults to the `GEMINI_API_KEY`
#'   environment variable.
#' @param model Model ID to use for requests.
#'
#' @return An object of class `gemini_config`.
#' @export
#'
#' @examples
#' \dontrun{
#' cfg <- gemini_config(api_key = Sys.getenv("GEMINI_API_KEY"))
#' }
gemini_config <- function(api_key = Sys.getenv("GEMINI_API_KEY"),
                          model = "gemini-2.0-flash") {
  if (!nzchar(api_key)) {
    stop(
      "No Gemini API key found. Pass `api_key` or set GEMINI_API_KEY.",
      call. = FALSE
    )
  }

  if (!nzchar(model)) {
    stop("`model` must be a non-empty string.", call. = FALSE)
  }

  structure(
    list(api_key = api_key, model = model),
    class = "gemini_config"
  )
}
