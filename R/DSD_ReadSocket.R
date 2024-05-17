#' A DSD That Reads from a Server Port
#'
#' Creates a `DSD_ReadStream` that reads from a port.
#'
#' @family Socket
#' @family dsd
#' 
#' @param host hostname.
#' @param port host port.
#' @param sleep number of seconds to wait to establish the connection.
#' @param ... further arguments are passed on to [DSD_ReadStream()].
#'
#' @returns A [stream::DSD] object.
#'
#' @examples
#' # find a free port
#' port <- httpuv::randomPort()
#' port
#' 
#' # create a background DSD process sending data to port 8001
#' rp1 <- DSD_Gaussians(k = 3, d = 3) %>% publish_DSD_via_Socket(port = port)
#' rp1
#'
#' Sys.sleep(2)  # wait for the socket to become available
#'
#' # create a DSD that connects to the socket. Note that we need to 
#' # specify the column names of the stream
#' dsd <- DSD_ReadSocket(port = port, col.names = c("x", "y", "z", ".class"))
#' dsd
#'
#' get_points(dsd, n = 10)
#' 
#' plot(dsd)
#'
#' close_stream(dsd)
#'
#' # end the DSD process. Note: that closing the connection above
#' # may already kill the process.
#' if (rp1$is_alive()) rp1$kill()
#' rp1
#' @export
DSD_ReadSocket <- function(host = "localhost", port, sleep = 2, ...) {
  con <- socketConnection(host, port, server = FALSE, open = 'r')
  Sys.sleep(sleep)
  DSD_ReadStream(con, ...)
}