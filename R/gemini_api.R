.gemini_build_url <- function(model) {
  sprintf("https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent", model)
}

.gemini_payload_from_prompt <- function(prompt) {
  list(
    contents = list(
      list(
        role = "user",
        parts = list(list(text = prompt))
      )
    )
  )
}

.gemini_extract_text <- function(response) {
  candidates <- response$candidates

  if (is.null(candidates) || length(candidates) == 0) {
    stop("Gemini response did not contain any candidates.", call. = FALSE)
  }

  parts <- candidates[[1]]$content$parts

  if (is.null(parts) || length(parts) == 0) {
    stop("Gemini response did not contain any text parts.", call. = FALSE)
  }

  text_parts <- vapply(parts, function(part) part$text %||% "", character(1))
  text_parts <- text_parts[nzchar(text_parts)]

  if (length(text_parts) == 0) {
    stop("Gemini response did not include text output.", call. = FALSE)
  }

  paste(text_parts, collapse = "\n")
}

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

.gemini_request <- function(config, body) {
  if (!inherits(config, "gemini_config")) {
    stop("`config` must come from `gemini_config()`.", call. = FALSE)
  }

  req <- httr2::request(.gemini_build_url(config$model)) |>
    httr2::req_url_query(key = config$api_key) |>
    httr2::req_headers(`Content-Type` = "application/json") |>
    httr2::req_body_json(body, auto_unbox = TRUE) |>
    httr2::req_error(is_error = function(resp) httr2::resp_status(resp) >= 400)

  resp <- httr2::req_perform(req)
  parsed <- httr2::resp_body_json(resp, simplifyVector = TRUE)

  list(
    text = .gemini_extract_text(parsed),
    raw = parsed
  )
}

#' Generate text with Gemini
#'
#' @param prompt User prompt as a single string.
#' @param config Gemini config created by [gemini_config()].
#' @param temperature Sampling temperature between 0 and 2.
#' @param max_output_tokens Maximum number of output tokens.
#'
#' @return A list with `text` and `raw`.
#' @export
#'
#' @examples
#' \dontrun{
#' cfg <- gemini_config()
#' gemini_generate("Explain heteroskedasticity in simple terms.", cfg)
#' }
gemini_generate <- function(prompt,
                            config = gemini_config(),
                            temperature = 0.7,
                            max_output_tokens = 512) {
  if (!is.character(prompt) || length(prompt) != 1 || !nzchar(prompt)) {
    stop("`prompt` must be a non-empty string.", call. = FALSE)
  }

  body <- .gemini_payload_from_prompt(prompt)
  body$generationConfig <- list(
    temperature = temperature,
    maxOutputTokens = as.integer(max_output_tokens)
  )

  .gemini_request(config, body)
}

#' Continue a chat conversation with Gemini
#'
#' @param messages A list of message objects. Each item should be a named list
#'   with `role` (`"user"` or `"model"`) and `content` (character scalar).
#' @param config Gemini config created by [gemini_config()].
#' @param temperature Sampling temperature between 0 and 2.
#' @param max_output_tokens Maximum number of output tokens.
#'
#' @return A list with `text` and `raw`.
#' @export
#'
#' @examples
#' \dontrun{
#' cfg <- gemini_config()
#' chat <- list(
#'   list(role = "user", content = "You are a statistics tutor."),
#'   list(role = "user", content = "What is omitted variable bias?")
#' )
#' gemini_chat(chat, cfg)
#' }
gemini_chat <- function(messages,
                        config = gemini_config(),
                        temperature = 0.7,
                        max_output_tokens = 512) {
  if (!is.list(messages) || length(messages) == 0) {
    stop("`messages` must be a non-empty list.", call. = FALSE)
  }

  contents <- lapply(messages, function(msg) {
    if (is.null(msg$role) || is.null(msg$content)) {
      stop("Each message must include `role` and `content`.", call. = FALSE)
    }

    if (!msg$role %in% c("user", "model")) {
      stop("`role` must be either 'user' or 'model'.", call. = FALSE)
    }

    if (!is.character(msg$content) || length(msg$content) != 1 || !nzchar(msg$content)) {
      stop("`content` must be a non-empty string.", call. = FALSE)
    }

    list(
      role = msg$role,
      parts = list(list(text = msg$content))
    )
  })

  body <- list(
    contents = contents,
    generationConfig = list(
      temperature = temperature,
      maxOutputTokens = as.integer(max_output_tokens)
    )
  )

  .gemini_request(config, body)
}
