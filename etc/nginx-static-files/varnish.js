// noinspection NodeCoreCodingAssistance
var fs = require('fs');

function chooseBackend(r) {
  try {
    fs.accessSync('/tmp/enable-varnish', fs.constants.R_OK);
    return 'varnish'
  } catch (e) {
    return 'direct'
  }
}

export default { chooseBackend };
