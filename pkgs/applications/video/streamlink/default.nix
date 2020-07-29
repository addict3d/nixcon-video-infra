{ stdenv, pythonPackages, fetchFromGitHub, rtmpdump, ffmpeg_3 }:

pythonPackages.buildPythonApplication rec {
  version = "1.5.0";
  pname = "streamlink";

  src = fetchFromGitHub {
    owner = "streamlink";
    repo = "streamlink";
    rev = version;
    sha256 = "00pishpyim3mcvr9njcbfhj79j85b5xhkslk3mspc2csqknw4k61";
  };

  checkInputs = with pythonPackages; [ pytest mock requests-mock freezegun ];

  propagatedBuildInputs = (with pythonPackages; [ pycryptodome requests iso-639 iso3166 websocket_client isodate ]) ++ [ rtmpdump ffmpeg_3 ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/streamlink/streamlink";
    description = "CLI for extracting streams from various websites to video player of your choosing";
    longDescription = ''
      Streamlink is a CLI utility that pipes flash videos from online
      streaming services to a variety of video players such as VLC, or
      alternatively, a browser.

      Streamlink is a fork of the livestreamer project.
    '';
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ dezgeg zraexy enzime ];
  };
}
