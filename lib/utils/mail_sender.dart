import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

mail({
  String id,
}) async {
  String username = 'verifiercause7@gmail.com';
  String password = 'TakeoffVerifier';
  print("mailsender: $id");

  final smtpServer = gmail(username, password);
  // Use the SmtpServer class to configure an SMTP server:
  // final smtpServer = SmtpServer('smtp.domain.com');
  // See the named arguments of SmtpServer for further configuration
  // options.

  // Create our message.
  final message = Message()
    ..from = Address(username, 'Cause Verifier')
    ..recipients.add('causeverification@takeoff.nyc')
    ..subject = 'Cause Verification $id'
    ..text = 'Verify the cause with id: $id';

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }

  var connection = PersistentConnection(smtpServer);

  // Send the first message
  await connection.send(message);

  // send the equivalent message
  //await connection.send(equivalentMessage);

  // close the connection
  await connection.close();
}
