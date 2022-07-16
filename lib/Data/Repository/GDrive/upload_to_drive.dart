import 'dart:io';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:mbm_elearning/Data/Repository/GDrive/secure_storage.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

const List<String> _scopes = [ga.DriveApi.driveFileScope];

class GoogleDrive {
  final storage = SecureStorage();
  //Get Authenticated Http Client
  Future<http.Client> getHttpClient() async {
    //Get Credentials
    var credentials = await storage.getCredentials();
    if (credentials["type"] == null) {
      //Needs user authentication
      var authClient = await clientViaUserConsent(
          ClientId(gdriveUploadClientId, gDriveUploadClientSecreat), _scopes,
          (url) {
        launch(url);
      });
      //Save Credentials
      await storage.saveCredentials(authClient.credentials.accessToken,
          authClient.credentials.refreshToken!);
      return authClient;
    } else {
      //Already authenticated
      return authenticatedClient(
          http.Client(),
          AccessCredentials(
              AccessToken(credentials["type"], credentials["data"],
                  DateTime.tryParse(credentials["expiry"])!),
              credentials["refreshToken"],
              _scopes));
    }
  }

  //Upload File
  Future<String?> upload(File file) async {
    var client = await getHttpClient();
    var drive = ga.DriveApi(client);
    ga.File fileToUpload = ga.File();
    fileToUpload.parents = [gDriveFolder];
    fileToUpload.name = p.basename(file.absolute.path);
    var response = await drive.files.create(fileToUpload,
        uploadMedia: ga.Media(file.openRead(), file.lengthSync()));
    return "https://drive.google.com/file/d/${response.id}";
  }
}
