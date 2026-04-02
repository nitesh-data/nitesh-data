\name{gemini_config}
\alias{gemini_config}
\title{Configure Gemini API credentials}
\usage{
gemini_config(api_key = Sys.getenv("GEMINI_API_KEY"), model = "gemini-2.0-flash")
}
\arguments{
  \item{api_key}{Gemini API key. Defaults to the \code{GEMINI_API_KEY} environment variable.}
  \item{model}{Model ID to use for requests.}
}
\value{An object of class \code{gemini_config}.}
\description{Configure Gemini API credentials and default model for requests.}
