import 'dart:async';

import 'package:flutter/services.dart';

/// The entry point for the Genius Scan SDK
class FlutterGeniusScan {
  static const MethodChannel _channel =
      const MethodChannel('flutter_genius_scan');

  /// Starts a scanning flow with 3 screens (Camera, Document Detection, Post Processing)
  ///
  /// It takes a [configuration] parameter which can take the following options:
  /// * `source`: `camera` or `image` (defaults to camera)
  /// * `sourceImageUrl`: an absolute image url, required if `source` is `image`. Example: `file:///var/…/image.png`
  /// * `multiPage`: boolean (defaults to true). If true, after a page is scanned, a prompt to scan another page will be displayed. If false, a single page will be scanned.
  /// * `multiPageFormat`: `pdf`, `tiff`, `none` (defaults to `pdf`)
  /// * `defaultFilter`: `none`, `blackAndWhite`, `monochrome`, `color`, `photo` (by default, the filter is chosen automatically)
  /// * `pdfPageSize`: `fit`, `a4`, `letter`, defaults to fit.
  /// * `pdfMaxScanDimension`: max dimension in pixels when images are scaled before PDF generation, for example 2000 to fit both height and width within 2000px. Defaults to 0, which means no scaling is performed.
  /// * `jpegQuality`: JPEG quality used to compress captured images. Between 0 and 100, 100 being the best quality. Default is 60.
  /// * `postProcessingActions`: an array with the desired actions to display during the post processing screen (defaults to all actions). Possible actions are `rotate`, `editFilter`.
  /// * `flashButtonHidden`: boolean (default to false)
  /// * `defaultFlashMode`: `auto`, `on`, `off` (default to `off`)
  /// * `foregroundColor`: string representing a color, must start with a `#`. The color of the icons, text (defaults to '#ffffff').
  /// * `backgroundColor`: string representing a color, must start with a `#`. The color of the toolbar, screen background (defaults to black)
  /// * `highlightColor`: string representing a color, must start with a `#`. The color of the image overlays (default to blue)
  /// * `menuColor`: string representing a color, must start with a `#`. The color of the menus (defaults to system defaults.)
  /// * `ocrConfiguration`: text recognition options. Text recognition will run on a background thread for every captured image. No text recognition will be applied if this parameter is not present.
  ///    * `languages`: list of language codes (eg `["eng"]`) for which to run text recognition. They should match the provided language files. Note that text recognition will take longer if multiple languages are specified.
  ///    * `languagesDirectoryUrl`: folder containing the language files used for text recognition. Language files can be downloaded from https://github.com/tesseract-ocr/tessdata_fast.
  ///
  /// It returns a `Future<Map>` containing:
  /// * `multiPageDocumentUrl`: a document containing all the scanned pages (example: "file://<filepath>.pdf")
  /// * `scans`: an array of scan objects. Each scan object has:
  ///    * `originalUrl`: The original file as scanned from the camera. "file://<filepath>.jpeg"
  ///    * `enhancedUrl`: The cropped and enhanced file, as processed by the SDK. "file://<filepath>.{jpeg|png}"
  ///    * `ocrResult`: the result of text recognition for this scan
  ///       * `text`: the raw text that was recognized
  static Future<Map> scanWithConfiguration(Map configuration) async {
    return await _channel.invokeMethod('scanWithConfiguration', configuration);
  }

  /// Sets the licence key of the SDK
  ///
  /// Returns a Future that is resolved if the licence key is valid and rejected if it is not.
  /// Note that, for testing purpose, you can also use the plugin without a licence key, but it will only work for 60 seconds.
  static Future<void> setLicenceKey(String licenceKey) async {
    await _channel.invokeMethod('setLicenceKey', licenceKey);
  }
}
