import subprocess

from flask import Flask
from subprocess import Popen, PIPE


application = Flask(__name__)
application.debug = True
@application.route('/', methods=['GET'])
def hello():
    ps = subprocess.Popen(('date', '+%a %H:%M:%S'), stdout=subprocess.PIPE)
    output = subprocess.check_output(('/usr/bin/figlet', '-f', '/tmp/figlet-2.2.5/fonts/standard.flf'), stdin=ps.stdout)
    ps.wait()
    return '<meta http-equiv="refresh" content="5" ><p><pre>' + str(output, 'utf-8') + '</pre></p>'
    #return '<p><pre>hello world</pre></p>'
if __name__ == "__main__":
      application.run(host='0.0.0.0')
