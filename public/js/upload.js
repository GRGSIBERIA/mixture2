function show_upload_form(access_key, policy, signature, fname_hash, host) {
  /*
  var upload = $("div#upload-post").append("<form method='post' class='dropzone' action='https://mixture-posts.s3.amazonaws.com/' enctype='multipart/form-data'></form>");
  $("div#upload-post > form").append(
    '<input type="hidden" name="key" value="uploads/${filename}">' + 
    '<input type="hidden" name="AWSAccessKeyId" value="' + access_key + '">' + 
    '<input type="hidden" name="acl" value="public-read">' + 
    '<input type="hidden" name="success_action_redirect" value="' + host + '">' + 
    '<input type="hidden" name="policy" value="' + policy + '">' + 
    '<input type="hidden" name="signature" value="' + signature + '">' + 
    '<input type="hidden" name="Content-Type" value="image/jpeg">' + 
    '<input name="file" type="file">' + 
    '<input type="submit" value="Upload File to S3">'
    );
  */
  $("div#upload-post").append(
    "<form id='upload-form'>" + 
    "<input type='file' name='file' id='upload-button' onchange='upload(" + fname_hash +")'>" + 
    '<input type="hidden" name="AWSAccessKeyId" value="' + access_key + '">' + 
    '<input type="hidden" name="acl" value="public-read">' + 
    '<input type="hidden" name="success_action_redirect" value="' + host + '">' + 
    '<input type="hidden" name="policy" value="' + policy + '">' + 
    '<input type="hidden" name="signature" value="' + signature + '">' + 
    "</form>");
}

function getExtention(fileName) {
  var ret = "nil";
  if (!fileName) {
    return ret;
  }
  var fileTypes = fileName.split(".");
  var len = fileTypes.length;
  if (len === 0) {
    return ret;
  }
  ret = fileTypes[len - 1];
  return ret;
}

function getContentType(extension) {
  var content_type = ""
  if (extension != "nil") {
    switch (extension) {
      case "jpg":
      case "jpeg":
        content_type = "image/jpeg";
        break;
      case "png":
        content_type = "image/png"
        break;
      case "txt":
      case "csv":
        content_type = "text/plain";
        break;
      case "zip":
        content_type = "application/zip"
        break;
    }
  }
  return content_type;
}

function upload(fname_hash) {
  var flist = document.getElementById("upload-button").files;
  var file_name = flist[0].name;
  var extension = getExtention(file_name).toLowerCase();
  var content_type = getContentType(extension);

  var form = $('#upload-form').get()[0];
  var form_data = new FormData(form);
  form_data.append("key", "uploads/" + fname_hash + "." + extension);
  form_data.append("Content-Type", content_type);

  $.ajax({
    type: "post",
    url:  "https://mixture-posts.s3.amazonaws.com/",
    //mimeType: "multipart/form-data",
    contentType: false,
    processData: false,
    data: form_data
  });
}