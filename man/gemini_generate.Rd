\name{gemini_generate}
\alias{gemini_generate}
\title{Generate text with Gemini}
\usage{
gemini_generate(
  prompt,
  config = gemini_config(),
  temperature = 0.7,
  max_output_tokens = 512
)
}
\arguments{
  \item{prompt}{User prompt as a single string.}
  \item{config}{Gemini config created by \code{gemini_config()}.}
  \item{temperature}{Sampling temperature between 0 and 2.}
  \item{max_output_tokens}{Maximum number of output tokens.}
}
\value{A list with \code{text} and \code{raw}.}
\description{Call the Gemini API with a single user prompt and return text output.}
