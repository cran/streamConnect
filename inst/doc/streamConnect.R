## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, comment = "#>")

## ----install, eval=FALSE------------------------------------------------------
# install.packages("streamConnect")

## ----load---------------------------------------------------------------------
library(streamConnect)

## ----find-socket--------------------------------------------------------------
run_code <- TRUE
tryCatch({
  port <- httpuv::randomPort()

  }, warning = function(w) {
    message("Ports unavailable: ", w)
    run_code <<- FALSE
  }, error = function(e) {
    message("Ports unavailable: ", e)
    run_code <<- FALSE
})

## ----socket-publish, eval=run_code--------------------------------------------
socket_process <- publish_DSD_via_Socket(
  DSD_Gaussians(k = 3, d = 2),
  port = port
)
socket_process

## ----socket-read, eval=run_code-----------------------------------------------
socket_dsd <- DSD_ReadSocket(
  port = port,
  col.names = c("x", "y", ".class")
)

points <- get_points(socket_dsd, n = 10)
head(points)

## ----socket-stop, eval=run_code-----------------------------------------------
close_stream(socket_dsd)
if (socket_process$is_alive()) socket_process$kill()

## ----webservice-start, eval=run_code------------------------------------------
clusterer_process <- publish_DSC_via_WebService(
  "DSC_DBSTREAM(r = .05)",
  port = port
)

clusterer <- DSC_WebService(paste0("http://127.0.0.1:", port))
clusterer

## ----webservice-update, eval=run_code-----------------------------------------
stream <- DSD_Gaussians(k = 3, d = 2, noise = 0.05)
update(clusterer, stream, n = 500)

get_centers(clusterer)
get_weights(clusterer)

## ----webservice-stop, eval=run_code-------------------------------------------
if (clusterer_process$is_alive()) clusterer_process$kill()

## ----webservice-stream, eval=run_code-----------------------------------------
source_process <- publish_DSD_via_WebService(
  "DSD_Gaussians(k = 3, d = 2)",
  port = port
)

remote_stream <- DSD_ReadWebService(paste0("http://127.0.0.1:", port))
get_points(remote_stream, n = 10)

## ----webservice-stream2, eval=run_code----------------------------------------
if (source_process$is_alive()) source_process$kill()

