\name{gemini_chat}
\alias{gemini_chat}
\title{Continue a chat conversation with Gemini}
\usage{
gemini_chat(
  messages,
  config = gemini_config(),
  temperature = 0.7,
  max_output_tokens = 512
)
}
\arguments{
  \item{messages}{A list of message objects with \code{role} and \code{content}.}
  \item{config}{Gemini config created by \code{gemini_config()}.}
  \item{temperature}{Sampling temperature between 0 and 2.}
  \item{max_output_tokens}{Maximum number of output tokens.}
}
\value{A list with \code{text} and \code{raw}.}
\description{Send a sequence of user/model messages to Gemini and return the latest model output.}
