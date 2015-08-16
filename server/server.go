package main

import (
	"flag"
	//"io/ioutil"
	"bytes"
	"io"
	"net/http"
	"path/filepath"
	"strconv"
)

var (
	port = flag.Int("port", 8080, "Port to listen")
)

const Version = "0.0.1"

type buffer struct {
	bytes.Buffer
}

func (b *buffer) Close() error {
	return nil
}

func HandleErr(err error) {
	if err != nil {
		log.Error("Error: %v\n", err)
	}
}

func proxy(w http.ResponseWriter, r *http.Request) {
	resp, err := http.Get("http://static.aqicn.org" + r.URL.RequestURI())
	HandleErr(err)
	defer resp.Body.Close()
	//body, err := ioutil.ReadAll(resp.Body)
	//io.Copy(buf, resp.Body)
	HandleErr(err)
	w.WriteHeader(resp.StatusCode)
	io.Copy(w, resp.Body)
}

func main() {
	flag.Parse()
	docroot, err := filepath.Abs("./html")
	HandleErr(err)
	hServe := new(http.Server)
	mux := http.NewServeMux()
	mux.HandleFunc("/mapi/", proxy)
	mux.Handle("/", http.StripPrefix("/", http.FileServer(http.Dir(docroot))))
	hServe.Handler = mux
	hServe.Addr = ":" + strconv.Itoa(*port)

	//":"+strconv.Itoa(*port),http.FileServer(http.Dir(docroot)) )
	log.Notice("server running at %s:%d. CTRL + C to shutdown\n", "http://localhost", *port)
	err = hServe.ListenAndServe()
	HandleErr(err)

}
