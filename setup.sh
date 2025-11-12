#!/bin/bash
yum update -y
yum install -y python3 pip
pip3 install flask boto3

cat <<'EOF' > /home/ec2-user/app.py
from flask import Flask, request, render_template_string
import boto3, os

app = Flask(__name__)
s3 = boto3.client('s3')
BUCKET = os.environ.get('BUCKET', 'photo-upload-ferguzman')

HTML = '''
<h2>Upload a Photo</h2>
<form method="post" enctype="multipart/form-data">
<input type="file" name="file"/>
<input type="submit"/>
</form>
'''

@app.route('/', methods=['GET', 'POST'])
def upload():
    if request.method == 'POST':
        f = request.files['file']
        s3.upload_fileobj(f, BUCKET, f.filename)
        return f"Uploaded {f.filename} to {BUCKET}"
    return render_template_string(HTML)

app.run(host='0.0.0.0', port=80)
EOF

nohup python3 /home/ec2-user/app.py &
