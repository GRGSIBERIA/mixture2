function upload(access_key, policy, signature, fname_hash) {
  $("div#upload-post").append("<form method='post' action='https://mixture-posts.s3.amazonaws.com/' enctype='multipart/form-data'>こんちは</form>");

  var uform = "div#upload-post > form";
  $(uform).append(
    '<input type="hidden" name="key" value="uploads/${filename}">'
    );
  $(uform).append(
    '<input type="hidden" name="AWSAccessKeyId" value="' + access_key + '">'
    );
  $(uform).append(
    '<input type="hidden" name="acl" value="public-read">'
    );
  $(uform).append(
    '<input type="hidden" name="success_action_redirect" value="http://localhost:3000/">'
    );
  $(uform).append(
    '<input type="hidden" name="policy" value="' + policy + '">'
    );
  $(uform).append(
    '<input type="hidden" name="signature" value="' + signature + '">'
    );
  $(uform).append(
    '<input type="hidden" name="Content-Type" value="image/jpeg">'
    );
}
