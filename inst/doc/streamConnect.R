## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, comment = "#>")

## ----install, eval=FALSE------------------------------------------------------
# install.packages("streamConnect")

## ----load---------------------------------------------------------------------
library(streamConnect)

## ----socket-publish-----------------------------------------------------------
port <- httpuv::randomPort()

socket_process <- publish_DSD_via_Socket(
  DSD_Gaussians(k = 3, d = 2),
  port = port
)
socket_process

## ----socket-read--------------------------------------------------------------
socket_dsd <- DSD_ReadSocket(
  port = port,
  col.names = c("x", "y", ".class")
)

points <- get_points(socket_dsd, n = 10)
head(points)

## ----socket-stop--------------------------------------------------------------
close_stream(socket_dsd)
if (socket_process$is_alive()) socket_process$kill()

## ----webservice-start---------------------------------------------------------
web_port <- httpuv::randomPort()

clusterer_process <- publish_DSC_via_WebService(
  "DSC_DBSTREAM(r = .05)",
  port = web_port
)

clusterer <- DSC_WebService(paste0("http://localhost:", web_port))
clusterer

## ----webservice-update--------------------------------------------------------
stream <- DSD_Gaussians(k = 3, d = 2, noise = 0.05)
update(clusterer, stream, n = 500)

get_centers(clusterer)
get_weights(clusterer)

## ----webservice-stop----------------------------------------------------------
if (clusterer_process$is_alive()) clusterer_process$kill()

## ----webservice-stream--------------------------------------------------------
port <- httpuv::randomPort()

source_process <- publish_DSD_via_WebService(
  "DSD_Gaussians(k = 3, d = 2)",
  port = port
)

remote_stream <- DSD_ReadWebService(paste0("http://localhost:", port))
get_points(remote_stream, n = 10)

## ----webservice-stream2-------------------------------------------------------
if (source_process$is_alive()) source_process$kill()

