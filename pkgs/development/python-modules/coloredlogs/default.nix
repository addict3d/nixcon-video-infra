{ lib, buildPythonPackage, fetchFromGitHub, stdenv, isPy3k, fetchpatch, humanfriendly, verboselogs, capturer, pytest, mock, utillinux }:

buildPythonPackage rec {
  pname = "coloredlogs";
  version = "14.0";

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-coloredlogs";
    rev = version;
    sha256 = "0rnmxwrim4razlv4vi3krxk5lc5ksck6h5374j8avqwplika7q2x";
  };

  # patch by risicle
  patches = lib.optional (stdenv.isDarwin && isPy3k) (fetchpatch {
    name = "darwin-py3-capture-fix.patch";
    url = "https://github.com/xolox/python-coloredlogs/pull/74.patch";
    sha256 = "0pk7k94iz0gdripw623vzdl4hd83vwhsfzshl8pbvh1n6swi0xx9";
  });

  checkPhase = ''
    PATH=$PATH:$out/bin pytest . -k "not test_plain_text_output_format \
                                     and not test_auto_install"
  '';
  checkInputs = [ pytest mock utillinux ];

  propagatedBuildInputs = [ humanfriendly verboselogs capturer ];

  meta = with lib; {
    description = "Colored stream handler for Python's logging module";
    homepage = "https://github.com/xolox/python-coloredlogs";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
