# geminiR

`geminiR` is a lightweight R package for calling the Google Gemini API.

## Features

- API key + model configuration helper
- Single-prompt text generation via `gemini_generate()`
- Basic multi-turn chat via `gemini_chat()`
- Raw JSON responses are returned for debugging and downstream parsing

## Installation

```r
# from local source
# install.packages(".", repos = NULL, type = "source")
```

## Setup

1. Get a Gemini API key from Google AI Studio.
2. Set it in your environment:

```r
Sys.setenv(GEMINI_API_KEY = "your_api_key_here")
```

## Usage

```r
library(geminiR)

cfg <- gemini_config(model = "gemini-2.0-flash")

res <- gemini_generate(
  prompt = "Summarize the central limit theorem in three bullet points.",
  config = cfg
)

cat(res$text)
```

### Chat example

```r
chat_messages <- list(
  list(role = "user", content = "You are an econometrics tutor."),
  list(role = "user", content = "Explain multicollinearity briefly.")
)

chat_res <- gemini_chat(chat_messages, config = cfg)
cat(chat_res$text)
```

## Notes

- This package currently uses the Gemini `generateContent` endpoint.
- Keep your API key private and never hardcode it into public repositories.
