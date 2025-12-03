// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:file_picker/file_picker.dart';
// // // // // // import 'package:flutter_pdfview/flutter_pdfview.dart';
// // // // // //
// // // // // // void main() {
// // // // // //   runApp(const StudyHighlightApp());
// // // // // // }
// // // // // //
// // // // // // class StudyHighlightApp extends StatelessWidget {
// // // // // //   const StudyHighlightApp({super.key});
// // // // // //
// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     return MaterialApp(
// // // // // //       title: 'Study Highlight',
// // // // // //       debugShowCheckedModeBanner: false,
// // // // // //       home: const StudyHomePage(),
// // // // // //     );
// // // // // //   }
// // // // // // }
// // // // // //
// // // // // // /// 홈 화면: PDF 선택
// // // // // // class StudyHomePage extends StatelessWidget {
// // // // // //   const StudyHomePage({super.key});
// // // // // //
// // // // // //   Future<void> _openPdf(BuildContext context) async {
// // // // // //     final result = await FilePicker.platform.pickFiles(
// // // // // //       type: FileType.custom,
// // // // // //       allowedExtensions: ['pdf'],
// // // // // //     );
// // // // // //
// // // // // //     if (result == null || result.files.single.path == null) return;
// // // // // //
// // // // // //     final path = result.files.single.path!;
// // // // // //
// // // // // //     Navigator.of(context).push(
// // // // // //       MaterialPageRoute(builder: (_) => PDFDrawScreen(path: path)),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     return Scaffold(
// // // // // //       backgroundColor: const Color(0xFFF5F5F5),
// // // // // //       appBar: AppBar(
// // // // // //         title: const Text('Study Highlight 노트'),
// // // // // //         centerTitle: true,
// // // // // //       ),
// // // // // //       body: Center(
// // // // // //         child: Column(
// // // // // //           mainAxisSize: MainAxisSize.min,
// // // // // //           children: [
// // // // // //             const Icon(Icons.note_alt_outlined, size: 80),
// // // // // //             const SizedBox(height: 16),
// // // // // //             const Text(
// // // // // //               'PDF를 선택해서 공부를 시작하세요.',
// // // // // //               style: TextStyle(fontSize: 16),
// // // // // //             ),
// // // // // //             const SizedBox(height: 24),
// // // // // //             ElevatedButton(
// // // // // //               onPressed: () => _openPdf(context),
// // // // // //               child: const Text('PDF 열기'),
// // // // // //             ),
// // // // // //           ],
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }
// // // // // //
// // // // // // // -----------------------------
// // // // // // // 드로잉 관련 모델
// // // // // // // -----------------------------
// // // // // //
// // // // // // enum DrawTool {
// // // // // //   pen,
// // // // // //   highlighter,
// // // // // //   eraser,
// // // // // // }
// // // // // //
// // // // // // class Stroke {
// // // // // //   Stroke({
// // // // // //     required this.points,
// // // // // //     required this.color,
// // // // // //     required this.width,
// // // // // //     required this.tool,
// // // // // //   });
// // // // // //
// // // // // //   final List<Offset> points;
// // // // // //   final Color color;
// // // // // //   final double width;
// // // // // //   final DrawTool tool;
// // // // // // }
// // // // // //
// // // // // // // -----------------------------
// // // // // // // Stroke 리스트를 그리는 Painter
// // // // // // // -----------------------------
// // // // // //
// // // // // // class DrawingPainter extends CustomPainter {
// // // // // //   final List<Stroke> strokes;
// // // // // //
// // // // // //   DrawingPainter(this.strokes);
// // // // // //
// // // // // //   @override
// // // // // //   void paint(Canvas canvas, Size size) {
// // // // // //     for (final stroke in strokes) {
// // // // // //       if (stroke.points.length < 2) continue;
// // // // // //
// // // // // //       final paint = Paint()
// // // // // //         ..color = (stroke.tool == DrawTool.highlighter)
// // // // // //             ? stroke.color.withOpacity(0.4)
// // // // // //             : stroke.color
// // // // // //         ..strokeWidth = stroke.width
// // // // // //         ..strokeCap = StrokeCap.round
// // // // // //         ..strokeJoin = StrokeJoin.round
// // // // // //         ..style = PaintingStyle.stroke;
// // // // // //
// // // // // //       for (int i = 0; i < stroke.points.length - 1; i++) {
// // // // // //         final p1 = stroke.points[i];
// // // // // //         final p2 = stroke.points[i + 1];
// // // // // //         canvas.drawLine(p1, p2, paint);
// // // // // //       }
// // // // // //     }
// // // // // //   }
// // // // // //
// // // // // //   @override
// // // // // //   bool shouldRepaint(covariant DrawingPainter oldDelegate) {
// // // // // //       // 리스트 내용이 바뀌면 무조건 다시 그리도록 처리
// // // // // //       return true;
// // // // // //   }
// // // // // // }
// // // // // //
// // // // // // // -----------------------------
// // // // // // // PDF + 드로잉 + 상단 툴바 화면
// // // // // // // -----------------------------
// // // // // //
// // // // // // class PDFDrawScreen extends StatefulWidget {
// // // // // //   final String path;
// // // // // //   const PDFDrawScreen({super.key, required this.path});
// // // // // //
// // // // // //   @override
// // // // // //   State<PDFDrawScreen> createState() => _PDFDrawScreenState();
// // // // // // }
// // // // // //
// // // // // // class _PDFDrawScreenState extends State<PDFDrawScreen> {
// // // // // //   final List<Stroke> _strokes = [];
// // // // // //   final List<Stroke> _redoStack = [];
// // // // // //
// // // // // //   Stroke? _currentStroke;
// // // // // //
// // // // // //   // 현재 도구/색상/두께
// // // // // //   DrawTool _tool = DrawTool.highlighter;
// // // // // //   Color _currentColor = Colors.yellowAccent;
// // // // // //   double _currentWidth = 16.0;
// // // // // //
// // // // // //   // -----------------------------
// // // // // //   // 드로잉 로직
// // // // // //   // -----------------------------
// // // // // //
// // // // // //   Offset _toLocal(Offset globalPosition) {
// // // // // //     final box = context.findRenderObject() as RenderBox?;
// // // // // //     if (box == null) return globalPosition;
// // // // // //     return box.globalToLocal(globalPosition);
// // // // // //   }
// // // // // //
// // // // // //   void _onPanStart(DragStartDetails details) {
// // // // // //     final pos = _toLocal(details.globalPosition);
// // // // // //
// // // // // //     // 지우개 모드는 Stroke를 새로 만들지 않고, 근처 Stroke 제거
// // // // // //     if (_tool == DrawTool.eraser) {
// // // // // //       _eraseAt(pos);
// // // // // //       return;
// // // // // //     }
// // // // // //
// // // // // //     final width = (_tool == DrawTool.highlighter)
// // // // // //         ? _currentWidth
// // // // // //         : (_currentWidth / 1.8).clamp(2.0, 12.0);
// // // // // //
// // // // // //     _currentStroke = Stroke(
// // // // // //       points: [pos],
// // // // // //       color: _currentColor,
// // // // // //       width: width,
// // // // // //       tool: _tool,
// // // // // //     );
// // // // // //
// // // // // //     setState(() {
// // // // // //       _strokes.add(_currentStroke!);
// // // // // //       _redoStack.clear();
// // // // // //     });
// // // // // //   }
// // // // // //
// // // // // //   void _onPanUpdate(DragUpdateDetails details) {
// // // // // //     final pos = _toLocal(details.globalPosition);
// // // // // //
// // // // // //     if (_tool == DrawTool.eraser) {
// // // // // //       _eraseAt(pos);
// // // // // //       return;
// // // // // //     }
// // // // // //
// // // // // //     if (_currentStroke == null) return;
// // // // // //
// // // // // //     setState(() {
// // // // // //       _currentStroke!.points.add(pos);
// // // // // //     });
// // // // // //   }
// // // // // //
// // // // // //   void _onPanEnd(DragEndDetails details) {
// // // // // //     _currentStroke = null;
// // // // // //   }
// // // // // //
// // // // // //   // 지우개: 현재 위치 근처에 있는 Stroke를 통째로 제거
// // // // // //   void _eraseAt(Offset pos) {
// // // // // //     const double threshold = 20.0;
// // // // // //
// // // // // //     setState(() {
// // // // // //       _strokes.removeWhere((stroke) {
// // // // // //         return stroke.points.any(
// // // // // //           (p) => (p - pos).distance <= threshold,
// // // // // //         );
// // // // // //       });
// // // // // //     });
// // // // // //   }
// // // // // //
// // // // // //   // Undo / Redo / Clear
// // // // // //   void _undo() {
// // // // // //     if (_strokes.isEmpty) return;
// // // // // //     setState(() {
// // // // // //       final last = _strokes.removeLast();
// // // // // //       _redoStack.add(last);
// // // // // //     });
// // // // // //   }
// // // // // //
// // // // // //   void _redo() {
// // // // // //     if (_redoStack.isEmpty) return;
// // // // // //     setState(() {
// // // // // //       final stroke = _redoStack.removeLast();
// // // // // //       _strokes.add(stroke);
// // // // // //     });
// // // // // //   }
// // // // // //
// // // // // //   void _clearAll() {
// // // // // //     setState(() {
// // // // // //       _strokes.clear();
// // // // // //       _redoStack.clear();
// // // // // //     });
// // // // // //   }
// // // // // //
// // // // // //   // -----------------------------
// // // // // //   // UI: 상단 툴바
// // // // // //   // -----------------------------
// // // // // //
// // // // // //   Widget _buildToolButton({
// // // // // //     required IconData icon,
// // // // // //     required DrawTool tool,
// // // // // //   }) {
// // // // // //     final isSelected = _tool == tool;
// // // // // //
// // // // // //     return IconButton(
// // // // // //       tooltip: tool == DrawTool.pen
// // // // // //           ? '펜'
// // // // // //           : tool == DrawTool.highlighter
// // // // // //               ? '형광펜'
// // // // // //               : '지우개',
// // // // // //       icon: Icon(
// // // // // //         icon,
// // // // // //         color: isSelected ? Colors.blueAccent : Colors.black54,
// // // // // //       ),
// // // // // //       onPressed: () {
// // // // // //         setState(() {
// // // // // //           _tool = tool;
// // // // // //         });
// // // // // //       },
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   Widget _buildColorDot(Color color) {
// // // // // //     final bool selected = _currentColor.value == color.value;
// // // // // //
// // // // // //     return GestureDetector(
// // // // // //       onTap: () {
// // // // // //         setState(() {
// // // // // //           _currentColor = color;
// // // // // //           if (_tool == DrawTool.eraser) {
// // // // // //             // 색 클릭하면 자동으로 형광펜으로 전환 (굿노트 느낌)
// // // // // //             _tool = DrawTool.highlighter;
// // // // // //           }
// // // // // //         });
// // // // // //       },
// // // // // //       child: Container(
// // // // // //         margin: const EdgeInsets.symmetric(horizontal: 4),
// // // // // //         width: selected ? 26 : 22,
// // // // // //         height: selected ? 26 : 22,
// // // // // //         decoration: BoxDecoration(
// // // // // //           color: color,
// // // // // //           shape: BoxShape.circle,
// // // // // //           border: Border.all(
// // // // // //             color: selected ? Colors.black87 : Colors.black26,
// // // // // //             width: selected ? 2 : 1,
// // // // // //           ),
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   PreferredSizeWidget _buildTopToolbar() {
// // // // // //     return PreferredSize(
// // // // // //       preferredSize: const Size.fromHeight(72),
// // // // // //       child: Container(
// // // // // //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
// // // // // //         decoration: const BoxDecoration(
// // // // // //           color: Colors.white,
// // // // // //           boxShadow: [
// // // // // //             BoxShadow(
// // // // // //               color: Colors.black12,
// // // // // //               blurRadius: 4,
// // // // // //               offset: Offset(0, 1),
// // // // // //             ),
// // // // // //           ],
// // // // // //         ),
// // // // // //         child: Column(
// // // // // //           children: [
// // // // // //             Row(
// // // // // //               children: [
// // // // // //                 // 돋보기(줌) 아이콘 자리 – 일단 동작은 안 하고 안내만 띄움
// // // // // //                 IconButton(
// // // // // //                   tooltip: '줌 (추후 구현 예정)',
// // // // // //                   icon: const Icon(Icons.search),
// // // // // //                   onPressed: () {
// // // // // //                     ScaffoldMessenger.of(context).showSnackBar(
// // // // // //                       const SnackBar(
// // // // // //                         content: Text('줌 기능은 나중에 구현할 예정입니다.'),
// // // // // //                         duration: Duration(seconds: 1),
// // // // // //                       ),
// // // // // //                     );
// // // // // //                   },
// // // // // //                 ),
// // // // // //
// // // // // //                 // 펜 / 형광펜 / 지우개
// // // // // //                 _buildToolButton(icon: Icons.edit, tool: DrawTool.pen),
// // // // // //                 _buildToolButton(
// // // // // //                     icon: Icons.border_color, tool: DrawTool.highlighter),
// // // // // //                 _buildToolButton(
// // // // // //                     icon: Icons.auto_fix_normal, tool: DrawTool.eraser),
// // // // // //
// // // // // //                 const SizedBox(width: 8),
// // // // // //
// // // // // //                 // (굿노트의 올가미/도형 자리는 일단 더미 버튼)
// // // // // //                 IconButton(
// // // // // //                   tooltip: '선택 도구 (추후 구현 예정)',
// // // // // //                   icon: const Icon(Icons.all_inclusive),
// // // // // //                   onPressed: () {
// // // // // //                     ScaffoldMessenger.of(context).showSnackBar(
// // // // // //                       const SnackBar(
// // // // // //                         content: Text('선택 도구는 나중에 구현할 예정입니다.'),
// // // // // //                         duration: Duration(seconds: 1),
// // // // // //                       ),
// // // // // //                     );
// // // // // //                   },
// // // // // //                 ),
// // // // // //                 IconButton(
// // // // // //                   tooltip: '도형 (추후 구현 예정)',
// // // // // //                   icon: const Icon(Icons.crop_square),
// // // // // //                   onPressed: () {
// // // // // //                     ScaffoldMessenger.of(context).showSnackBar(
// // // // // //                       const SnackBar(
// // // // // //                         content: Text('도형 기능은 나중에 구현할 예정입니다.'),
// // // // // //                         duration: Duration(seconds: 1),
// // // // // //                       ),
// // // // // //                     );
// // // // // //                   },
// // // // // //                 ),
// // // // // //
// // // // // //                 const Spacer(),
// // // // // //
// // // // // //                 // 되돌리기 / 다시실행 / 전체 삭제
// // // // // //                 IconButton(
// // // // // //                   tooltip: '되돌리기',
// // // // // //                   icon: const Icon(Icons.undo),
// // // // // //                   onPressed: _undo,
// // // // // //                 ),
// // // // // //                 IconButton(
// // // // // //                   tooltip: '다시 실행',
// // // // // //                   icon: const Icon(Icons.redo),
// // // // // //                   onPressed: _redo,
// // // // // //                 ),
// // // // // //                 IconButton(
// // // // // //                   tooltip: '전체 지우기',
// // // // // //                   icon: const Icon(Icons.delete_outline),
// // // // // //                   onPressed: _clearAll,
// // // // // //                 ),
// // // // // //               ],
// // // // // //             ),
// // // // // //
// // // // // //             // 색상 + 두께 슬라이더 줄
// // // // // //             Row(
// // // // // //               children: [
// // // // // //                 _buildColorDot(Colors.yellowAccent),
// // // // // //                 _buildColorDot(Colors.lightBlueAccent),
// // // // // //                 _buildColorDot(Colors.pinkAccent),
// // // // // //                 _buildColorDot(Colors.greenAccent),
// // // // // //                 _buildColorDot(Colors.orangeAccent),
// // // // // //                 const SizedBox(width: 12),
// // // // // //                 const Text(
// // // // // //                   '두께',
// // // // // //                   style: TextStyle(fontSize: 12),
// // // // // //                 ),
// // // // // //                 Expanded(
// // // // // //                   child: Slider(
// // // // // //                     value: _currentWidth,
// // // // // //                     min: 4,
// // // // // //                     max: 28,
// // // // // //                     divisions: 12,
// // // // // //                     onChanged: (value) {
// // // // // //                       setState(() {
// // // // // //                         _currentWidth = value;
// // // // // //                       });
// // // // // //                     },
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ],
// // // // // //             ),
// // // // // //           ],
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // //
// // // // // //   // -----------------------------
// // // // // //   // 화면 전체 빌드
// // // // // //   // -----------------------------
// // // // // //
// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     return Scaffold(
// // // // // //       appBar: AppBar(
// // // // // //         title: const Text('PDF Viewer'),
// // // // // //         centerTitle: true,
// // // // // //         bottom: _buildTopToolbar(),
// // // // // //       ),
// // // // // //       body: Stack(
// // // // // //         children: [
// // // // // //           // PDF
// // // // // //           Positioned.fill(
// // // // // //             child: PDFView(
// // // // // //               filePath: widget.path,
// // // // // //               enableSwipe: true,
// // // // // //               swipeHorizontal: true,
// // // // // //               autoSpacing: true,
// // // // // //               pageFling: true,
// // // // // //             ),
// // // // // //           ),
// // // // // //           // 드로잉 레이어
// // // // // //           Positioned.fill(
// // // // // //             child: GestureDetector(
// // // // // //               behavior: HitTestBehavior.translucent,
// // // // // //               onPanStart: _onPanStart,
// // // // // //               onPanUpdate: _onPanUpdate,
// // // // // //               onPanEnd: _onPanEnd,
// // // // // //               child: CustomPaint(
// // // // // //                 painter: DrawingPainter(_strokes),
// // // // // //               ),
// // // // // //             ),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }
// // // // //
// // // // //
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:file_picker/file_picker.dart';
// // // // // import 'package:flutter_pdfview/flutter_pdfview.dart';
// // // // //
// // // // // void main() {
// // // // //   runApp(const StudyHighlightApp());
// // // // // }
// // // // //
// // // // // class StudyHighlightApp extends StatelessWidget {
// // // // //   const StudyHighlightApp({super.key});
// // // // //
// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return MaterialApp(
// // // // //       title: 'Study Highlight',
// // // // //       debugShowCheckedModeBanner: false,
// // // // //       home: const StudyHomePage(),
// // // // //     );
// // // // //   }
// // // // // }
// // // // //
// // // // // /// 홈 화면: PDF 선택
// // // // // class StudyHomePage extends StatelessWidget {
// // // // //   const StudyHomePage({super.key});
// // // // //
// // // // //   Future<void> _openPdf(BuildContext context) async {
// // // // //     final result = await FilePicker.platform.pickFiles(
// // // // //       type: FileType.custom,
// // // // //       allowedExtensions: ['pdf'],
// // // // //     );
// // // // //
// // // // //     if (result == null || result.files.single.path == null) return;
// // // // //
// // // // //     final path = result.files.single.path!;
// // // // //
// // // // //     Navigator.of(context).push(
// // // // //       MaterialPageRoute(builder: (_) => PDFDrawScreen(path: path)),
// // // // //     );
// // // // //   }
// // // // //
// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Scaffold(
// // // // //       backgroundColor: const Color(0xFFF5F5F5),
// // // // //       appBar: AppBar(
// // // // //         title: const Text('Study Highlight 노트'),
// // // // //         centerTitle: true,
// // // // //       ),
// // // // //       body: Center(
// // // // //         child: Column(
// // // // //           mainAxisSize: MainAxisSize.min,
// // // // //           children: [
// // // // //             const Icon(Icons.note_alt_outlined, size: 80),
// // // // //             const SizedBox(height: 16),
// // // // //             const Text(
// // // // //               'PDF를 선택해서 공부를 시작하세요.',
// // // // //               style: TextStyle(fontSize: 16),
// // // // //             ),
// // // // //             const SizedBox(height: 24),
// // // // //             ElevatedButton(
// // // // //               onPressed: () => _openPdf(context),
// // // // //               child: const Text('PDF 열기'),
// // // // //             ),
// // // // //           ],
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }
// // // // //
// // // // // // -----------------------------
// // // // // // 드로잉 관련 모델
// // // // // // -----------------------------
// // // // //
// // // // // enum DrawTool {
// // // // //   pen,
// // // // //   highlighter,
// // // // //   eraser,
// // // // // }
// // // // //
// // // // // class Stroke {
// // // // //   Stroke({
// // // // //     required this.points,
// // // // //     required this.color,
// // // // //     required this.width,
// // // // //     required this.tool,
// // // // //   });
// // // // //
// // // // //   final List<Offset> points;
// // // // //   final Color color;
// // // // //   final double width;
// // // // //   final DrawTool tool;
// // // // // }
// // // // //
// // // // // // -----------------------------
// // // // // // Stroke 리스트를 그리는 Painter
// // // // // // -----------------------------
// // // // //
// // // // // class DrawingPainter extends CustomPainter {
// // // // //   final List<Stroke> strokes;
// // // // //
// // // // //   DrawingPainter(this.strokes);
// // // // //
// // // // //   @override
// // // // //   void paint(Canvas canvas, Size size) {
// // // // //     for (final stroke in strokes) {
// // // // //       if (stroke.points.length < 2) continue;
// // // // //
// // // // //       final paint = Paint()
// // // // //         ..color = (stroke.tool == DrawTool.highlighter)
// // // // //             ? stroke.color.withOpacity(0.4)
// // // // //             : stroke.color
// // // // //         ..strokeWidth = stroke.width
// // // // //         ..strokeCap = StrokeCap.round
// // // // //         ..strokeJoin = StrokeJoin.round
// // // // //         ..style = PaintingStyle.stroke;
// // // // //
// // // // //       for (int i = 0; i < stroke.points.length - 1; i++) {
// // // // //         final p1 = stroke.points[i];
// // // // //         final p2 = stroke.points[i + 1];
// // // // //         canvas.drawLine(p1, p2, paint);
// // // // //       }
// // // // //     }
// // // // //   }
// // // // //
// // // // //   @override
// // // // //   bool shouldRepaint(covariant DrawingPainter oldDelegate) {
// // // // //     // 리스트 내용이 바뀌면 무조건 다시 그리도록 처리
// // // // //     return true;
// // // // //   }
// // // // // }
// // // // //
// // // // // // -----------------------------
// // // // // // PDF + 드로잉 + 상단 툴바 + 오른쪽 AI 패널 화면
// // // // // // -----------------------------
// // // // //
// // // // // class PDFDrawScreen extends StatefulWidget {
// // // // //   final String path;
// // // // //   const PDFDrawScreen({super.key, required this.path});
// // // // //
// // // // //   @override
// // // // //   State<PDFDrawScreen> createState() => _PDFDrawScreenState();
// // // // // }
// // // // //
// // // // // class _PDFDrawScreenState extends State<PDFDrawScreen> {
// // // // //   final List<Stroke> _strokes = [];
// // // // //   final List<Stroke> _redoStack = [];
// // // // //
// // // // //   Stroke? _currentStroke;
// // // // //
// // // // //   // 현재 도구/색상/두께
// // // // //   DrawTool _tool = DrawTool.highlighter;
// // // // //   Color _currentColor = Colors.yellowAccent;
// // // // //   double _currentWidth = 16.0;
// // // // //
// // // // //   // 캔버스 영역 기준 좌표 변환용 키
// // // // //   final GlobalKey _canvasKey = GlobalKey();
// // // // //
// // // // //   // -----------------------------
// // // // //   // 헬퍼: 색상 → 태그 레이블
// // // // //   // -----------------------------
// // // // //   String get _currentTagLabel {
// // // // //     if (_currentColor.value == Colors.yellowAccent.value) {
// // // // //       return '복습(Review)';
// // // // //     } else if (_currentColor.value == Colors.lightBlueAccent.value) {
// // // // //       return '심화(Deep)';
// // // // //     } else if (_currentColor.value == Colors.pinkAccent.value) {
// // // // //       return '예제(Example)';
// // // // //     } else if (_currentColor.value == Colors.greenAccent.value) {
// // // // //       return '정리(Summary)';
// // // // //     } else if (_currentColor.value == Colors.orangeAccent.value) {
// // // // //       return '기타(Custom)';
// // // // //     } else {
// // // // //       return '태그 미지정';
// // // // //     }
// // // // //   }
// // // // //
// // // // //   // -----------------------------
// // // // //   // 드로잉 로직
// // // // //   // -----------------------------
// // // // //
// // // // //   Offset _toLocal(Offset globalPosition) {
// // // // //     final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
// // // // //     if (box == null) return globalPosition;
// // // // //     return box.globalToLocal(globalPosition);
// // // // //   }
// // // // //
// // // // //   void _onPanStart(DragStartDetails details) {
// // // // //     final pos = _toLocal(details.globalPosition);
// // // // //
// // // // //     // 지우개 모드는 Stroke를 새로 만들지 않고, 근처 Stroke 제거
// // // // //     if (_tool == DrawTool.eraser) {
// // // // //       _eraseAt(pos);
// // // // //       return;
// // // // //     }
// // // // //
// // // // //     final width = (_tool == DrawTool.highlighter)
// // // // //         ? _currentWidth
// // // // //         : (_currentWidth / 1.8).clamp(2.0, 12.0);
// // // // //
// // // // //     _currentStroke = Stroke(
// // // // //       points: [pos],
// // // // //       color: _currentColor,
// // // // //       width: width,
// // // // //       tool: _tool,
// // // // //     );
// // // // //
// // // // //     setState(() {
// // // // //       _strokes.add(_currentStroke!);
// // // // //       _redoStack.clear();
// // // // //     });
// // // // //   }
// // // // //
// // // // //   void _onPanUpdate(DragUpdateDetails details) {
// // // // //     final pos = _toLocal(details.globalPosition);
// // // // //
// // // // //     if (_tool == DrawTool.eraser) {
// // // // //       _eraseAt(pos);
// // // // //       return;
// // // // //     }
// // // // //
// // // // //     if (_currentStroke == null) return;
// // // // //
// // // // //     setState(() {
// // // // //       _currentStroke!.points.add(pos);
// // // // //     });
// // // // //   }
// // // // //
// // // // //   void _onPanEnd(DragEndDetails details) {
// // // // //     _currentStroke = null;
// // // // //   }
// // // // //
// // // // //   // 지우개: 현재 위치 근처에 있는 Stroke를 통째로 제거
// // // // //   void _eraseAt(Offset pos) {
// // // // //     const double threshold = 20.0;
// // // // //
// // // // //     setState(() {
// // // // //       _strokes.removeWhere((stroke) {
// // // // //         return stroke.points.any(
// // // // //           (p) => (p - pos).distance <= threshold,
// // // // //         );
// // // // //       });
// // // // //     });
// // // // //   }
// // // // //
// // // // //   // Undo / Redo / Clear
// // // // //   void _undo() {
// // // // //     if (_strokes.isEmpty) return;
// // // // //     setState(() {
// // // // //       final last = _strokes.removeLast();
// // // // //       _redoStack.add(last);
// // // // //     });
// // // // //   }
// // // // //
// // // // //   void _redo() {
// // // // //     if (_redoStack.isEmpty) return;
// // // // //     setState(() {
// // // // //       final stroke = _redoStack.removeLast();
// // // // //       _strokes.add(stroke);
// // // // //     });
// // // // //   }
// // // // //
// // // // //   void _clearAll() {
// // // // //     setState(() {
// // // // //       _strokes.clear();
// // // // //       _redoStack.clear();
// // // // //     });
// // // // //   }
// // // // //
// // // // //   // -----------------------------
// // // // //   // UI: 상단 툴바
// // // // //   // -----------------------------
// // // // //
// // // // //   Widget _buildToolButton({
// // // // //     required IconData icon,
// // // // //     required DrawTool tool,
// // // // //   }) {
// // // // //     final isSelected = _tool == tool;
// // // // //
// // // // //     return IconButton(
// // // // //       tooltip: tool == DrawTool.pen
// // // // //           ? '펜'
// // // // //           : tool == DrawTool.highlighter
// // // // //               ? '형광펜'
// // // // //               : '지우개',
// // // // //       icon: Icon(
// // // // //         icon,
// // // // //         color: isSelected ? Colors.blueAccent : Colors.black54,
// // // // //       ),
// // // // //       onPressed: () {
// // // // //         setState(() {
// // // // //           _tool = tool;
// // // // //         });
// // // // //       },
// // // // //     );
// // // // //   }
// // // // //
// // // // //   Widget _buildColorDot(Color color) {
// // // // //     final bool selected = _currentColor.value == color.value;
// // // // //
// // // // //     return GestureDetector(
// // // // //       onTap: () {
// // // // //         setState(() {
// // // // //           _currentColor = color;
// // // // //           if (_tool == DrawTool.eraser) {
// // // // //             // 색 클릭하면 자동으로 형광펜으로 전환
// // // // //             _tool = DrawTool.highlighter;
// // // // //           }
// // // // //         });
// // // // //       },
// // // // //       child: Container(
// // // // //         margin: const EdgeInsets.symmetric(horizontal: 4),
// // // // //         width: selected ? 26 : 22,
// // // // //         height: selected ? 26 : 22,
// // // // //         decoration: BoxDecoration(
// // // // //           color: color,
// // // // //           shape: BoxShape.circle,
// // // // //           border: Border.all(
// // // // //             color: selected ? Colors.black87 : Colors.black26,
// // // // //             width: selected ? 2 : 1,
// // // // //           ),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // //
// // // // //   PreferredSizeWidget _buildTopToolbar() {
// // // // //     return PreferredSize(
// // // // //       preferredSize: const Size.fromHeight(72),
// // // // //       child: Container(
// // // // //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
// // // // //         decoration: const BoxDecoration(
// // // // //           color: Colors.white,
// // // // //           boxShadow: [
// // // // //             BoxShadow(
// // // // //               color: Colors.black12,
// // // // //               blurRadius: 4,
// // // // //               offset: Offset(0, 1),
// // // // //             ),
// // // // //           ],
// // // // //         ),
// // // // //         child: Column(
// // // // //           children: [
// // // // //             Row(
// // // // //               children: [
// // // // //                 // 줌 자리 (추후 구현)
// // // // //                 IconButton(
// // // // //                   tooltip: '줌 (추후 구현 예정)',
// // // // //                   icon: const Icon(Icons.search),
// // // // //                   onPressed: () {
// // // // //                     ScaffoldMessenger.of(context).showSnackBar(
// // // // //                       const SnackBar(
// // // // //                         content: Text('줌 기능은 나중에 구현할 예정입니다.'),
// // // // //                         duration: Duration(seconds: 1),
// // // // //                       ),
// // // // //                     );
// // // // //                   },
// // // // //                 ),
// // // // //
// // // // //                 // 펜 / 형광펜 / 지우개
// // // // //                 _buildToolButton(icon: Icons.edit, tool: DrawTool.pen),
// // // // //                 _buildToolButton(
// // // // //                     icon: Icons.border_color, tool: DrawTool.highlighter),
// // // // //                 _buildToolButton(
// // // // //                     icon: Icons.auto_fix_normal, tool: DrawTool.eraser),
// // // // //
// // // // //                 const SizedBox(width: 8),
// // // // //
// // // // //                 // 선택 도구 / 도형 (더미)
// // // // //                 IconButton(
// // // // //                   tooltip: '선택 도구 (추후 구현 예정)',
// // // // //                   icon: const Icon(Icons.all_inclusive),
// // // // //                   onPressed: () {
// // // // //                     ScaffoldMessenger.of(context).showSnackBar(
// // // // //                       const SnackBar(
// // // // //                         content: Text('선택 도구는 나중에 구현할 예정입니다.'),
// // // // //                         duration: Duration(seconds: 1),
// // // // //                       ),
// // // // //                     );
// // // // //                   },
// // // // //                 ),
// // // // //                 IconButton(
// // // // //                   tooltip: '도형 (추후 구현 예정)',
// // // // //                   icon: const Icon(Icons.crop_square),
// // // // //                   onPressed: () {
// // // // //                     ScaffoldMessenger.of(context).showSnackBar(
// // // // //                       const SnackBar(
// // // // //                         content: Text('도형 기능은 나중에 구현할 예정입니다.'),
// // // // //                         duration: Duration(seconds: 1),
// // // // //                       ),
// // // // //                     );
// // // // //                   },
// // // // //                 ),
// // // // //
// // // // //                 const Spacer(),
// // // // //
// // // // //                 // 되돌리기 / 다시 실행 / 전체 삭제
// // // // //                 IconButton(
// // // // //                   tooltip: '되돌리기',
// // // // //                   icon: const Icon(Icons.undo),
// // // // //                   onPressed: _undo,
// // // // //                 ),
// // // // //                 IconButton(
// // // // //                   tooltip: '다시 실행',
// // // // //                   icon: const Icon(Icons.redo),
// // // // //                   onPressed: _redo,
// // // // //                 ),
// // // // //                 IconButton(
// // // // //                   tooltip: '전체 지우기',
// // // // //                   icon: const Icon(Icons.delete_outline),
// // // // //                   onPressed: _clearAll,
// // // // //                 ),
// // // // //               ],
// // // // //             ),
// // // // //
// // // // //             // 색상 + 두께 슬라이더 줄
// // // // //             Row(
// // // // //               children: [
// // // // //                 _buildColorDot(Colors.yellowAccent),
// // // // //                 _buildColorDot(Colors.lightBlueAccent),
// // // // //                 _buildColorDot(Colors.pinkAccent),
// // // // //                 _buildColorDot(Colors.greenAccent),
// // // // //                 _buildColorDot(Colors.orangeAccent),
// // // // //                 const SizedBox(width: 12),
// // // // //                 const Text(
// // // // //                   '두께',
// // // // //                   style: TextStyle(fontSize: 12),
// // // // //                 ),
// // // // //                 Expanded(
// // // // //                   child: Slider(
// // // // //                     value: _currentWidth,
// // // // //                     min: 4,
// // // // //                     max: 28,
// // // // //                     divisions: 12,
// // // // //                     onChanged: (value) {
// // // // //                       setState(() {
// // // // //                         _currentWidth = value;
// // // // //                       });
// // // // //                     },
// // // // //                   ),
// // // // //                 ),
// // // // //               ],
// // // // //             ),
// // // // //           ],
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // //
// // // // //   // -----------------------------
// // // // //   // 오른쪽 AI 패널 UI
// // // // //   // -----------------------------
// // // // //
// // // // //   Widget _buildRightAiPanel() {
// // // // //     return Container(
// // // // //       width: 320,
// // // // //       decoration: const BoxDecoration(
// // // // //         color: Color(0xFFF7F8FA),
// // // // //         border: Border(
// // // // //           left: BorderSide(color: Color(0xFFDDDDDD)),
// // // // //         ),
// // // // //       ),
// // // // //       child: Column(
// // // // //         children: [
// // // // //           // 헤더
// // // // //           Container(
// // // // //             padding:
// // // // //                 const EdgeInsets.only(top: 12, bottom: 8, left: 16, right: 16),
// // // // //             decoration: const BoxDecoration(
// // // // //               color: Colors.white,
// // // // //               boxShadow: [
// // // // //                 BoxShadow(
// // // // //                   color: Colors.black12,
// // // // //                   blurRadius: 3,
// // // // //                   offset: Offset(0, 1),
// // // // //                 ),
// // // // //               ],
// // // // //             ),
// // // // //             child: Column(
// // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // //               children: [
// // // // //                 const Text(
// // // // //                   'AI 학습 패널',
// // // // //                   style: TextStyle(
// // // // //                     fontWeight: FontWeight.bold,
// // // // //                     fontSize: 16,
// // // // //                   ),
// // // // //                 ),
// // // // //                 const SizedBox(height: 6),
// // // // //                 Row(
// // // // //                   children: [
// // // // //                     Container(
// // // // //                       width: 10,
// // // // //                       height: 10,
// // // // //                       margin: const EdgeInsets.only(right: 6),
// // // // //                       decoration: BoxDecoration(
// // // // //                         color: _currentColor,
// // // // //                         shape: BoxShape.circle,
// // // // //                         border: Border.all(color: Colors.black26),
// // // // //                       ),
// // // // //                     ),
// // // // //                     Expanded(
// // // // //                       child: Text(
// // // // //                         '현재 태그: $_currentTagLabel',
// // // // //                         style: const TextStyle(
// // // // //                           fontSize: 12,
// // // // //                           color: Colors.black87,
// // // // //                         ),
// // // // //                         overflow: TextOverflow.ellipsis,
// // // // //                       ),
// // // // //                     ),
// // // // //                   ],
// // // // //                 ),
// // // // //                 const SizedBox(height: 4),
// // // // //                 const Text(
// // // // //                   '형광펜 색상에 따라 복습 / 심화 / 예제 요약이 생성될 예정입니다.',
// // // // //                   style: TextStyle(
// // // // //                     fontSize: 11,
// // // // //                     color: Colors.black54,
// // // // //                   ),
// // // // //                 ),
// // // // //               ],
// // // // //             ),
// // // // //           ),
// // // // //
// // // // //           // 내용 영역
// // // // //           Expanded(
// // // // //             child: Padding(
// // // // //               padding:
// // // // //                   const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
// // // // //               child: ListView(
// // // // //                 children: [
// // // // //                   const SizedBox(height: 8),
// // // // //                   const Text(
// // // // //                     '요약 미리보기',
// // // // //                     style: TextStyle(
// // // // //                       fontWeight: FontWeight.w600,
// // // // //                       fontSize: 13,
// // // // //                     ),
// // // // //                   ),
// // // // //                   const SizedBox(height: 6),
// // // // //                   Container(
// // // // //                     padding: const EdgeInsets.all(10),
// // // // //                     decoration: BoxDecoration(
// // // // //                       color: Colors.white,
// // // // //                       borderRadius: BorderRadius.circular(8),
// // // // //                       border: Border.all(color: const Color(0xFFDDDDDD)),
// // // // //                     ),
// // // // //                     child: const Text(
// // // // //                       '형광펜으로 문장을 긋고 나면, 해당 구간의 요약과 문제, 심화 설명이 이 영역에 표시될 예정입니다.',
// // // // //                       style: TextStyle(fontSize: 12, height: 1.4),
// // // // //                     ),
// // // // //                   ),
// // // // //                   const SizedBox(height: 16),
// // // // //                   const Text(
// // // // //                     'AI 작업 히스토리',
// // // // //                     style: TextStyle(
// // // // //                       fontWeight: FontWeight.w600,
// // // // //                       fontSize: 13,
// // // // //                     ),
// // // // //                   ),
// // // // //                   const SizedBox(height: 6),
// // // // //                   _buildHistoryPlaceholder(
// // // // //                     title: '복습 요약',
// // // // //                     description: '노랑 태그로 긋는 구간이 여기에 쌓일 예정입니다.',
// // // // //                   ),
// // // // //                   const SizedBox(height: 8),
// // // // //                   _buildHistoryPlaceholder(
// // // // //                     title: '심화 설명',
// // // // //                     description: '하늘/파랑 태그로 긋는 구간의 심화 설명이 저장됩니다.',
// // // // //                   ),
// // // // //                   const SizedBox(height: 8),
// // // // //                   _buildHistoryPlaceholder(
// // // // //                     title: '예제/문제',
// // // // //                     description: '예제 태그로 표시한 내용을 기반으로 자동 문제가 생성됩니다.',
// // // // //                   ),
// // // // //                 ],
// // // // //               ),
// // // // //             ),
// // // // //           ),
// // // // //
// // // // //           // 하단 버튼 영역
// // // // //           Container(
// // // // //             padding:
// // // // //                 const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
// // // // //             decoration: const BoxDecoration(
// // // // //               color: Colors.white,
// // // // //               border: Border(
// // // // //                 top: BorderSide(color: Color(0xFFDDDDDD)),
// // // // //               ),
// // // // //             ),
// // // // //             child: Column(
// // // // //               children: [
// // // // //                 SizedBox(
// // // // //                   width: double.infinity,
// // // // //                   child: ElevatedButton.icon(
// // // // //                     icon: const Icon(Icons.bolt_outlined, size: 18),
// // // // //                     label: const Text(
// // // // //                       '현재 형광펜 구간 요약 생성',
// // // // //                       style: TextStyle(fontSize: 13),
// // // // //                     ),
// // // // //                     onPressed: () {
// // // // //                       ScaffoldMessenger.of(context).showSnackBar(
// // // // //                         const SnackBar(
// // // // //                           content: Text('AI 요약 기능은 다음 단계에서 연결할 예정입니다.'),
// // // // //                           duration: Duration(seconds: 1),
// // // // //                         ),
// // // // //                       );
// // // // //                     },
// // // // //                   ),
// // // // //                 ),
// // // // //                 const SizedBox(height: 6),
// // // // //                 SizedBox(
// // // // //                   width: double.infinity,
// // // // //                   child: OutlinedButton(
// // // // //                     child: const Text(
// // // // //                       '전체 복습 콘텐츠 보기',
// // // // //                       style: TextStyle(fontSize: 12),
// // // // //                     ),
// // // // //                     onPressed: () {
// // // // //                       ScaffoldMessenger.of(context).showSnackBar(
// // // // //                         const SnackBar(
// // // // //                           content: Text('복습 콘텐츠 화면은 추후 구현 예정입니다.'),
// // // // //                           duration: Duration(seconds: 1),
// // // // //                         ),
// // // // //                       );
// // // // //                     },
// // // // //                   ),
// // // // //                 ),
// // // // //               ],
// // // // //             ),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // //
// // // // //   static Widget _buildHistoryPlaceholder({
// // // // //     required String title,
// // // // //     required String description,
// // // // //   }) {
// // // // //     return Container(
// // // // //       padding: const EdgeInsets.all(10),
// // // // //       decoration: BoxDecoration(
// // // // //         color: const Color(0xFFFFFFFF),
// // // // //         borderRadius: BorderRadius.circular(8),
// // // // //         border: Border.all(color: const Color(0xFFE0E0E0)),
// // // // //       ),
// // // // //       child: Column(
// // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // //         children: [
// // // // //           Text(
// // // // //             title,
// // // // //             style: const TextStyle(
// // // // //               fontWeight: FontWeight.w600,
// // // // //               fontSize: 12,
// // // // //             ),
// // // // //           ),
// // // // //           const SizedBox(height: 4),
// // // // //           Text(
// // // // //             description,
// // // // //             style: const TextStyle(
// // // // //               fontSize: 11,
// // // // //               color: Colors.black54,
// // // // //               height: 1.3,
// // // // //             ),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // //
// // // // //   // -----------------------------
// // // // //   // 화면 전체 빌드
// // // // //   // -----------------------------
// // // // //
// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Scaffold(
// // // // //       appBar: AppBar(
// // // // //         title: const Text('Study Highlight · PDF Viewer'),
// // // // //         centerTitle: true,
// // // // //         bottom: _buildTopToolbar(),
// // // // //       ),
// // // // //       body: Row(
// // // // //         children: [
// // // // //           // 왼쪽: PDF + 드로잉 (메인 작업 영역)
// // // // //           Expanded(
// // // // //             child: Stack(
// // // // //               children: [
// // // // //                 // PDF
// // // // //                 Positioned.fill(
// // // // //                   child: PDFView(
// // // // //                     filePath: widget.path,
// // // // //                     enableSwipe: true,
// // // // //                     swipeHorizontal: true,
// // // // //                     autoSpacing: true,
// // // // //                     pageFling: true,
// // // // //                   ),
// // // // //                 ),
// // // // //                 // 드로잉 레이어
// // // // //                 Positioned.fill(
// // // // //                   child: GestureDetector(
// // // // //                     behavior: HitTestBehavior.translucent,
// // // // //                     onPanStart: _onPanStart,
// // // // //                     onPanUpdate: _onPanUpdate,
// // // // //                     onPanEnd: _onPanEnd,
// // // // //                     child: Container(
// // // // //                       key: _canvasKey,
// // // // //                       // 색은 투명
// // // // //                       color: Colors.transparent,
// // // // //                       child: CustomPaint(
// // // // //                         painter: DrawingPainter(_strokes),
// // // // //                       ),
// // // // //                     ),
// // // // //                   ),
// // // // //                 ),
// // // // //               ],
// // // // //             ),
// // // // //           ),
// // // // //
// // // // //           // 오른쪽: AI 패널
// // // // //           _buildRightAiPanel(),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }
// // // // import 'package:flutter/material.dart';
// // // // import 'package:file_picker/file_picker.dart';
// // // // import 'package:flutter_pdfview/flutter_pdfview.dart';
// // // //
// // // // void main() {
// // // //   runApp(const StudyHighlightApp());
// // // // }
// // // //
// // // // class StudyHighlightApp extends StatelessWidget {
// // // //   const StudyHighlightApp({super.key});
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return MaterialApp(
// // // //       title: 'Study Highlight',
// // // //       debugShowCheckedModeBanner: false,
// // // //       home: const StudyHomePage(),
// // // //     );
// // // //   }
// // // // }
// // // //
// // // // /// 홈 화면: PDF 선택
// // // // class StudyHomePage extends StatelessWidget {
// // // //   const StudyHomePage({super.key});
// // // //
// // // //   Future<void> _openPdf(BuildContext context) async {
// // // //     final result = await FilePicker.platform.pickFiles(
// // // //       type: FileType.custom,
// // // //       allowedExtensions: ['pdf'],
// // // //     );
// // // //
// // // //     if (result == null || result.files.single.path == null) return;
// // // //
// // // //     final path = result.files.single.path!;
// // // //
// // // //     Navigator.of(context).push(
// // // //       MaterialPageRoute(builder: (_) => PDFDrawScreen(path: path)),
// // // //     );
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       backgroundColor: const Color(0xFFF5F5F5),
// // // //       appBar: AppBar(
// // // //         title: const Text('Study Highlight 노트'),
// // // //         centerTitle: true,
// // // //       ),
// // // //       body: Center(
// // // //         child: Column(
// // // //           mainAxisSize: MainAxisSize.min,
// // // //           children: [
// // // //             const Icon(Icons.note_alt_outlined, size: 80),
// // // //             const SizedBox(height: 16),
// // // //             const Text(
// // // //               'PDF를 선택해서 공부를 시작하세요.',
// // // //               style: TextStyle(fontSize: 16),
// // // //             ),
// // // //             const SizedBox(height: 24),
// // // //             ElevatedButton(
// // // //               onPressed: () => _openPdf(context),
// // // //               child: const Text('PDF 열기'),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // //
// // // // // -----------------------------
// // // // // 드로잉 관련 모델
// // // // // -----------------------------
// // // //
// // // // enum DrawTool {
// // // //   pen,
// // // //   highlighter,
// // // //   eraser,
// // // // }
// // // //
// // // // class Stroke {
// // // //   Stroke({
// // // //     required this.points,
// // // //     required this.color,
// // // //     required this.width,
// // // //     required this.tool,
// // // //   });
// // // //
// // // //   final List<Offset> points;
// // // //   final Color color;
// // // //   final double width;
// // // //   final DrawTool tool;
// // // // }
// // // //
// // // // /// 형광펜 Stroke를 기반으로 만든 "하이라이트 영역"
// // // // /// 나중에 여기에서 텍스트 추출 결과(content)만 붙이면 됨.
// // // // class HighlightRegion {
// // // //   HighlightRegion({
// // // //     required this.page,
// // // //     required this.rectNormalized,
// // // //     required this.color,
// // // //   });
// // // //
// // // //   final int page; // 0 기반 현재 페이지
// // // //   final Rect rectNormalized; // 0~1 로 정규화된 좌표
// // // //   final Color color;
// // // //
// // // //   Map<String, dynamic> toJson() {
// // // //     return {
// // // //       'page': page,
// // // //       'rect': {
// // // //         'left': rectNormalized.left,
// // // //         'top': rectNormalized.top,
// // // //         'right': rectNormalized.right,
// // // //         'bottom': rectNormalized.bottom,
// // // //       },
// // // //       'color': color.value.toRadixString(16),
// // // //     };
// // // //   }
// // // //
// // // //   @override
// // // //   String toString() => toJson().toString();
// // // // }
// // // //
// // // // // -----------------------------
// // // // // Stroke 리스트를 그리는 Painter
// // // // // -----------------------------
// // // //
// // // // class DrawingPainter extends CustomPainter {
// // // //   final List<Stroke> strokes;
// // // //
// // // //   DrawingPainter(this.strokes);
// // // //
// // // //   @override
// // // //   void paint(Canvas canvas, Size size) {
// // // //     for (final stroke in strokes) {
// // // //       if (stroke.points.length < 2) continue;
// // // //
// // // //       final paint = Paint()
// // // //         ..color = (stroke.tool == DrawTool.highlighter)
// // // //             ? stroke.color.withOpacity(0.7)
// // // //             : stroke.color
// // // //         ..strokeWidth = stroke.width
// // // //         ..strokeCap = StrokeCap.round
// // // //         ..strokeJoin = StrokeJoin.round
// // // //         ..style = PaintingStyle.stroke;
// // // //
// // // //       for (int i = 0; i < stroke.points.length - 1; i++) {
// // // //         final p1 = stroke.points[i];
// // // //         final p2 = stroke.points[i + 1];
// // // //         canvas.drawLine(p1, p2, paint);
// // // //       }
// // // //     }
// // // //   }
// // // //
// // // //   @override
// // // //   bool shouldRepaint(covariant DrawingPainter oldDelegate) {
// // // //     return true;
// // // //   }
// // // // }
// // // //
// // // // // -----------------------------
// // // // // PDF + 드로잉 + 상단 툴바 + 오른쪽 AI 패널 화면
// // // // // -----------------------------
// // // //
// // // // class PDFDrawScreen extends StatefulWidget {
// // // //   final String path;
// // // //   const PDFDrawScreen({super.key, required this.path});
// // // //
// // // //   @override
// // // //   State<PDFDrawScreen> createState() => _PDFDrawScreenState();
// // // // }
// // // //
// // // // class _PDFDrawScreenState extends State<PDFDrawScreen> {
// // // //   final List<Stroke> _strokes = [];
// // // //   final List<Stroke> _redoStack = [];
// // // //
// // // //   Stroke? _currentStroke;
// // // //
// // // //   // 현재 도구/색상/두께
// // // //   DrawTool _tool = DrawTool.highlighter;
// // // //   Color _currentColor = Colors.yellowAccent;
// // // //   double _currentWidth = 16.0;
// // // //
// // // //   // PDF 페이지 상태
// // // //   int _currentPage = 0;
// // // //   int _totalPages = 0;
// // // //
// // // //   // 형광펜 하이라이트 영역 리스트
// // // //   final List<HighlightRegion> _highlights = [];
// // // //
// // // //   // 캔버스 영역 기준 좌표 변환용 키
// // // //   final GlobalKey _canvasKey = GlobalKey();
// // // //
// // // //   // -----------------------------
// // // //   // 헬퍼: 색상 → 태그 레이블
// // // //   // -----------------------------
// // // //   String get _currentTagLabel {
// // // //     if (_currentColor.value == Colors.yellowAccent.value) {
// // // //       return '복습(Review)';
// // // //     } else if (_currentColor.value == Colors.lightBlueAccent.value) {
// // // //       return '심화(Deep)';
// // // //     } else if (_currentColor.value == Colors.pinkAccent.value) {
// // // //       return '예제(Example)';
// // // //     } else if (_currentColor.value == Colors.greenAccent.value) {
// // // //       return '정리(Summary)';
// // // //     } else if (_currentColor.value == Colors.orangeAccent.value) {
// // // //       return '기타(Custom)';
// // // //     } else {
// // // //       return '태그 미지정';
// // // //     }
// // // //   }
// // // //
// // // //   // -----------------------------
// // // //   // 드로잉 로직
// // // //   // -----------------------------
// // // //
// // // //   Offset _toLocal(Offset globalPosition) {
// // // //     final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
// // // //     if (box == null) return globalPosition;
// // // //     return box.globalToLocal(globalPosition);
// // // //   }
// // // //
// // // //   void _onPanStart(DragStartDetails details) {
// // // //     final pos = _toLocal(details.globalPosition);
// // // //
// // // //     // 지우개 모드는 Stroke를 새로 만들지 않고, 근처 Stroke 제거
// // // //     if (_tool == DrawTool.eraser) {
// // // //       _eraseAt(pos);
// // // //       return;
// // // //     }
// // // //
// // // //     final width = (_tool == DrawTool.highlighter)
// // // //         ? _currentWidth
// // // //         : (_currentWidth / 1.8).clamp(2.0, 12.0);
// // // //
// // // //     _currentStroke = Stroke(
// // // //       points: [pos],
// // // //       color: _currentColor,
// // // //       width: width,
// // // //       tool: _tool,
// // // //     );
// // // //
// // // //     setState(() {
// // // //       _strokes.add(_currentStroke!);
// // // //       _redoStack.clear();
// // // //     });
// // // //   }
// // // //
// // // //   void _onPanUpdate(DragUpdateDetails details) {
// // // //     final pos = _toLocal(details.globalPosition);
// // // //
// // // //     if (_tool == DrawTool.eraser) {
// // // //       _eraseAt(pos);
// // // //       return;
// // // //     }
// // // //
// // // //     if (_currentStroke == null) return;
// // // //
// // // //     setState(() {
// // // //       _currentStroke!.points.add(pos);
// // // //     });
// // // //   }
// // // //
// // // //   void _onPanEnd(DragEndDetails details) {
// // // //     // 여기에서 형광펜 Stroke라면 바운딩 박스를 계산해서 하이라이트로 저장
// // // //     if (_currentStroke != null && _currentStroke!.tool == DrawTool.highlighter) {
// // // //       _saveHighlightFromStroke(_currentStroke!);
// // // //     }
// // // //     _currentStroke = null;
// // // //   }
// // // //
// // // //   // Stroke → HighlightRegion 변환
// // // //   void _saveHighlightFromStroke(Stroke stroke) {
// // // //     if (stroke.points.length < 2) return;
// // // //
// // // //     final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
// // // //     if (box == null) return;
// // // //
// // // //     final size = box.size;
// // // //
// // // //     double minX = stroke.points.first.dx;
// // // //     double maxX = stroke.points.first.dx;
// // // //     double minY = stroke.points.first.dy;
// // // //     double maxY = stroke.points.first.dy;
// // // //
// // // //     for (final p in stroke.points) {
// // // //       if (p.dx < minX) minX = p.dx;
// // // //       if (p.dx > maxX) maxX = p.dx;
// // // //       if (p.dy < minY) minY = p.dy;
// // // //       if (p.dy > maxY) maxY = p.dy;
// // // //     }
// // // //
// // // //     // 약간의 패딩 추가
// // // //     const padding = 4.0;
// // // //     minX = (minX - padding).clamp(0.0, size.width);
// // // //     maxX = (maxX + padding).clamp(0.0, size.width);
// // // //     minY = (minY - padding).clamp(0.0, size.height);
// // // //     maxY = (maxY + padding).clamp(0.0, size.height);
// // // //
// // // //     final rect = Rect.fromLTRB(minX, minY, maxX, maxY);
// // // //
// // // //     // 0~1 로 정규화
// // // //     final normalized = Rect.fromLTRB(
// // // //       rect.left / size.width,
// // // //       rect.top / size.height,
// // // //       rect.right / size.width,
// // // //       rect.bottom / size.height,
// // // //     );
// // // //
// // // //     final region = HighlightRegion(
// // // //       page: _currentPage,
// // // //       rectNormalized: normalized,
// // // //       color: stroke.color,
// // // //     );
// // // //
// // // //     setState(() {
// // // //       _highlights.add(region);
// // // //     });
// // // //
// // // //     // 디버그 로그
// // // //     debugPrint('New highlight: $region');
// // // //   }
// // // //
// // // //   // 지우개: 현재 위치 근처에 있는 Stroke를 통째로 제거
// // // //   void _eraseAt(Offset pos) {
// // // //     const double threshold = 20.0;
// // // //
// // // //     setState(() {
// // // //       _strokes.removeWhere((stroke) {
// // // //         return stroke.points.any(
// // // //           (p) => (p - pos).distance <= threshold,
// // // //         );
// // // //       });
// // // //
// // // //       // 하이라이트도 대략 같은 위치에 있으면 제거
// // // //       _highlights.removeWhere((region) {
// // // //         final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
// // // //         if (box == null) return false;
// // // //         final size = box.size;
// // // //
// // // //         // 정규화 역변환해서 대략적인 박스 중심 계산
// // // //         final rect = Rect.fromLTRB(
// // // //           region.rectNormalized.left * size.width,
// // // //           region.rectNormalized.top * size.height,
// // // //           region.rectNormalized.right * size.width,
// // // //           region.rectNormalized.bottom * size.height,
// // // //         );
// // // //         final center = rect.center;
// // // //         return (center - pos).distance <= threshold;
// // // //       });
// // // //     });
// // // //   }
// // // //
// // // //   // Undo / Redo / Clear
// // // //   void _undo() {
// // // //     if (_strokes.isEmpty) return;
// // // //     setState(() {
// // // //       final last = _strokes.removeLast();
// // // //       _redoStack.add(last);
// // // //       // 하이라이트도 가장 최근 것을 하나 제거(단순 동기화)
// // // //       if (_highlights.isNotEmpty) {
// // // //         _highlights.removeLast();
// // // //       }
// // // //     });
// // // //   }
// // // //
// // // //   void _redo() {
// // // //     if (_redoStack.isEmpty) return;
// // // //     setState(() {
// // // //       final stroke = _redoStack.removeLast();
// // // //       _strokes.add(stroke);
// // // //       // Redo 시 하이라이트는 다시 계산하는 식으로 가는 것이 정확하지만
// // // //       // 지금은 단순화해서 자동 복원은 하지 않음
// // // //     });
// // // //   }
// // // //
// // // //   void _clearAll() {
// // // //     setState(() {
// // // //       _strokes.clear();
// // // //       _redoStack.clear();
// // // //       _highlights.clear();
// // // //     });
// // // //   }
// // // //
// // // //   // -----------------------------
// // // //   // UI: 상단 툴바
// // // //   // -----------------------------
// // // //
// // // //   Widget _buildToolButton({
// // // //     required IconData icon,
// // // //     required DrawTool tool,
// // // //   }) {
// // // //     final isSelected = _tool == tool;
// // // //
// // // //     return IconButton(
// // // //       tooltip: tool == DrawTool.pen
// // // //           ? '펜'
// // // //           : tool == DrawTool.highlighter
// // // //               ? '형광펜'
// // // //               : '지우개',
// // // //       icon: Icon(
// // // //         icon,
// // // //         color: isSelected ? Colors.blueAccent : Colors.black54,
// // // //       ),
// // // //       onPressed: () {
// // // //         setState(() {
// // // //           _tool = tool;
// // // //         });
// // // //       },
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildColorDot(Color color) {
// // // //     final bool selected = _currentColor.value == color.value;
// // // //
// // // //     return GestureDetector(
// // // //       onTap: () {
// // // //         setState(() {
// // // //           _currentColor = color;
// // // //           if (_tool == DrawTool.eraser) {
// // // //             _tool = DrawTool.highlighter;
// // // //           }
// // // //         });
// // // //       },
// // // //       child: Container(
// // // //         margin: const EdgeInsets.symmetric(horizontal: 4),
// // // //         width: selected ? 26 : 22,
// // // //         height: selected ? 26 : 22,
// // // //         decoration: BoxDecoration(
// // // //           color: color,
// // // //           shape: BoxShape.circle,
// // // //           border: Border.all(
// // // //             color: selected ? Colors.black87 : Colors.black26,
// // // //             width: selected ? 2 : 1,
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   PreferredSizeWidget _buildTopToolbar() {
// // // //     return PreferredSize(
// // // //       preferredSize: const Size.fromHeight(72),
// // // //       child: Container(
// // // //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
// // // //         decoration: const BoxDecoration(
// // // //           color: Colors.white,
// // // //           boxShadow: [
// // // //             BoxShadow(
// // // //               color: Colors.black12,
// // // //               blurRadius: 4,
// // // //               offset: Offset(0, 1),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //         child: Column(
// // // //           children: [
// // // //             Row(
// // // //               children: [
// // // //                 // 줌 자리 (추후 구현)
// // // //                 IconButton(
// // // //                   tooltip: '줌 (추후 구현 예정)',
// // // //                   icon: const Icon(Icons.search),
// // // //                   onPressed: () {
// // // //                     ScaffoldMessenger.of(context).showSnackBar(
// // // //                       const SnackBar(
// // // //                         content: Text('줌 기능은 나중에 구현할 예정입니다.'),
// // // //                         duration: Duration(seconds: 1),
// // // //                       ),
// // // //                     );
// // // //                   },
// // // //                 ),
// // // //
// // // //                 // 펜 / 형광펜 / 지우개
// // // //                 _buildToolButton(icon: Icons.edit, tool: DrawTool.pen),
// // // //                 _buildToolButton(
// // // //                     icon: Icons.border_color, tool: DrawTool.highlighter),
// // // //                 _buildToolButton(
// // // //                     icon: Icons.auto_fix_normal, tool: DrawTool.eraser),
// // // //
// // // //                 const SizedBox(width: 8),
// // // //
// // // //                 // 선택 도구 / 도형 (더미)
// // // //                 IconButton(
// // // //                   tooltip: '선택 도구 (추후 구현 예정)',
// // // //                   icon: const Icon(Icons.all_inclusive),
// // // //                   onPressed: () {
// // // //                     ScaffoldMessenger.of(context).showSnackBar(
// // // //                       const SnackBar(
// // // //                         content: Text('선택 도구는 나중에 구현할 예정입니다.'),
// // // //                         duration: Duration(seconds: 1),
// // // //                       ),
// // // //                     );
// // // //                   },
// // // //                 ),
// // // //                 IconButton(
// // // //                   tooltip: '도형 (추후 구현 예정)',
// // // //                   icon: const Icon(Icons.crop_square),
// // // //                   onPressed: () {
// // // //                     ScaffoldMessenger.of(context).showSnackBar(
// // // //                       const SnackBar(
// // // //                         content: Text('도형 기능은 나중에 구현할 예정입니다.'),
// // // //                         duration: Duration(seconds: 1),
// // // //                       ),
// // // //                     );
// // // //                   },
// // // //                 ),
// // // //
// // // //                 const Spacer(),
// // // //
// // // //                 // 되돌리기 / 다시 실행 / 전체 삭제
// // // //                 IconButton(
// // // //                   tooltip: '되돌리기',
// // // //                   icon: const Icon(Icons.undo),
// // // //                   onPressed: _undo,
// // // //                 ),
// // // //                 IconButton(
// // // //                   tooltip: '다시 실행',
// // // //                   icon: const Icon(Icons.redo),
// // // //                   onPressed: _redo,
// // // //                 ),
// // // //                 IconButton(
// // // //                   tooltip: '전체 지우기',
// // // //                   icon: const Icon(Icons.delete_outline),
// // // //                   onPressed: _clearAll,
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //
// // // //             // 색상 + 두께 슬라이더 줄
// // // //             Row(
// // // //               children: [
// // // //                 _buildColorDot(Colors.yellowAccent),
// // // //                 _buildColorDot(Colors.lightBlueAccent),
// // // //                 _buildColorDot(Colors.pinkAccent),
// // // //                 _buildColorDot(Colors.greenAccent),
// // // //                 _buildColorDot(Colors.orangeAccent),
// // // //                 const SizedBox(width: 12),
// // // //                 const Text(
// // // //                   '두께',
// // // //                   style: TextStyle(fontSize: 12),
// // // //                 ),
// // // //                 Expanded(
// // // //                   child: Slider(
// // // //                     value: _currentWidth,
// // // //                     min: 4,
// // // //                     max: 28,
// // // //                     divisions: 12,
// // // //                     onChanged: (value) {
// // // //                       setState(() {
// // // //                         _currentWidth = value;
// // // //                       });
// // // //                     },
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   // -----------------------------
// // // //   // 오른쪽 AI 패널 UI
// // // //   // -----------------------------
// // // //
// // // //   Widget _buildRightAiPanel() {
// // // //     final currentPageHighlights =
// // // //         _highlights.where((h) => h.page == _currentPage).toList();
// // // //
// // // //     return Container(
// // // //       width: 320,
// // // //       decoration: const BoxDecoration(
// // // //         color: Color(0xFFF7F8FA),
// // // //         border: Border(
// // // //           left: BorderSide(color: Color(0xFFDDDDDD)),
// // // //         ),
// // // //       ),
// // // //       child: Column(
// // // //         children: [
// // // //           // 헤더
// // // //           Container(
// // // //             padding:
// // // //                 const EdgeInsets.only(top: 12, bottom: 8, left: 16, right: 16),
// // // //             decoration: const BoxDecoration(
// // // //               color: Colors.white,
// // // //               boxShadow: [
// // // //                 BoxShadow(
// // // //                   color: Colors.black12,
// // // //                   blurRadius: 3,
// // // //                   offset: Offset(0, 1),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //             child: Column(
// // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // //               children: [
// // // //                 const Text(
// // // //                   'AI 학습 패널',
// // // //                   style: TextStyle(
// // // //                     fontWeight: FontWeight.bold,
// // // //                     fontSize: 16,
// // // //                   ),
// // // //                 ),
// // // //                 const SizedBox(height: 6),
// // // //                 Row(
// // // //                   children: [
// // // //                     Container(
// // // //                       width: 10,
// // // //                       height: 10,
// // // //                       margin: const EdgeInsets.only(right: 6),
// // // //                       decoration: BoxDecoration(
// // // //                         color: _currentColor,
// // // //                         shape: BoxShape.circle,
// // // //                         border: Border.all(color: Colors.black26),
// // // //                       ),
// // // //                     ),
// // // //                     Expanded(
// // // //                       child: Text(
// // // //                         '현재 태그: $_currentTagLabel',
// // // //                         style: const TextStyle(
// // // //                           fontSize: 12,
// // // //                           color: Colors.black87,
// // // //                         ),
// // // //                         overflow: TextOverflow.ellipsis,
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //                 const SizedBox(height: 4),
// // // //                 Text(
// // // //                   '현재 페이지: ${_currentPage + 1} / $_totalPages, '
// // // //                   '하이라이트 ${currentPageHighlights.length}개',
// // // //                   style: const TextStyle(
// // // //                     fontSize: 11,
// // // //                     color: Colors.black54,
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //
// // // //           // 내용 영역
// // // //           Expanded(
// // // //             child: Padding(
// // // //               padding:
// // // //                   const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
// // // //               child: ListView(
// // // //                 children: [
// // // //                   const SizedBox(height: 8),
// // // //                   const Text(
// // // //                     '하이라이트 좌표 (디버그 용)',
// // // //                     style: TextStyle(
// // // //                       fontWeight: FontWeight.w600,
// // // //                       fontSize: 13,
// // // //                     ),
// // // //                   ),
// // // //                   const SizedBox(height: 6),
// // // //                   if (currentPageHighlights.isEmpty)
// // // //                     Container(
// // // //                       padding: const EdgeInsets.all(10),
// // // //                       decoration: BoxDecoration(
// // // //                         color: Colors.white,
// // // //                         borderRadius: BorderRadius.circular(8),
// // // //                         border:
// // // //                             Border.all(color: const Color(0xFFDDDDDD)),
// // // //                       ),
// // // //                       child: const Text(
// // // //                         '이 페이지에서 형광펜으로 문장을 긋고 나면, '
// // // //                         '정규화된 좌표 정보가 여기에 표시됩니다.',
// // // //                         style: TextStyle(fontSize: 12, height: 1.4),
// // // //                       ),
// // // //                     )
// // // //                   else
// // // //                     ...currentPageHighlights.map((h) {
// // // //                       final r = h.rectNormalized;
// // // //                       return Container(
// // // //                         margin: const EdgeInsets.only(bottom: 6),
// // // //                         padding: const EdgeInsets.all(8),
// // // //                         decoration: BoxDecoration(
// // // //                           color: Colors.white,
// // // //                           borderRadius: BorderRadius.circular(6),
// // // //                           border: Border.all(
// // // //                               color: const Color(0xFFE0E0E0)),
// // // //                         ),
// // // //                         child: Text(
// // // //                           'page=${h.page}, '
// // // //                           'left=${r.left.toStringAsFixed(3)}, '
// // // //                           'top=${r.top.toStringAsFixed(3)}, '
// // // //                           'right=${r.right.toStringAsFixed(3)}, '
// // // //                           'bottom=${r.bottom.toStringAsFixed(3)}',
// // // //                           style: const TextStyle(
// // // //                             fontSize: 11,
// // // //                             height: 1.3,
// // // //                           ),
// // // //                         ),
// // // //                       );
// // // //                     }),
// // // //                   const SizedBox(height: 16),
// // // //                   const Text(
// // // //                     'AI 작업 히스토리 (향후)',
// // // //                     style: TextStyle(
// // // //                       fontWeight: FontWeight.w600,
// // // //                       fontSize: 13,
// // // //                     ),
// // // //                   ),
// // // //                   const SizedBox(height: 6),
// // // //                   _buildHistoryPlaceholder(
// // // //                     title: '복습 요약',
// // // //                     description: '노랑 태그로 긋는 구간이 여기에 쌓일 예정입니다.',
// // // //                   ),
// // // //                   const SizedBox(height: 8),
// // // //                   _buildHistoryPlaceholder(
// // // //                     title: '심화 설명',
// // // //                     description: '하늘 태그로 긋는 구간의 심화 설명이 저장됩니다.',
// // // //                   ),
// // // //                   const SizedBox(height: 8),
// // // //                   _buildHistoryPlaceholder(
// // // //                     title: '예제/문제',
// // // //                     description: '예제 태그를 기반으로 자동 문제가 생성됩니다.',
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //           ),
// // // //
// // // //           // 하단 버튼 영역
// // // //           Container(
// // // //             padding:
// // // //                 const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
// // // //             decoration: const BoxDecoration(
// // // //               color: Colors.white,
// // // //               border: Border(
// // // //                 top: BorderSide(color: Color(0xFFDDDDDD)),
// // // //               ),
// // // //             ),
// // // //             child: Column(
// // // //               children: [
// // // //                 SizedBox(
// // // //                   width: double.infinity,
// // // //                   child: ElevatedButton.icon(
// // // //                     icon: const Icon(Icons.code, size: 18),
// // // //                     label: const Text(
// // // //                       '하이라이트 JSON 로그',
// // // //                       style: TextStyle(fontSize: 13),
// // // //                     ),
// // // //                     onPressed: () {
// // // //                       for (final h in _highlights) {
// // // //                         debugPrint(h.toString());
// // // //                       }
// // // //                       ScaffoldMessenger.of(context).showSnackBar(
// // // //                         const SnackBar(
// // // //                           content: Text('디버그 콘솔에서 하이라이트 정보를 확인할 수 있습니다.'),
// // // //                           duration: Duration(seconds: 1),
// // // //                         ),
// // // //                       );
// // // //                     },
// // // //                   ),
// // // //                 ),
// // // //                 const SizedBox(height: 6),
// // // //                 SizedBox(
// // // //                   width: double.infinity,
// // // //                   child: OutlinedButton(
// // // //                     child: const Text(
// // // //                       '전체 복습 콘텐츠 보기 (향후)',
// // // //                       style: TextStyle(fontSize: 12),
// // // //                     ),
// // // //                     onPressed: () {
// // // //                       ScaffoldMessenger.of(context).showSnackBar(
// // // //                         const SnackBar(
// // // //                           content: Text('복습 콘텐츠 화면은 추후 구현 예정입니다.'),
// // // //                           duration: Duration(seconds: 1),
// // // //                         ),
// // // //                       );
// // // //                     },
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   static Widget _buildHistoryPlaceholder({
// // // //     required String title,
// // // //     required String description,
// // // //   }) {
// // // //     return Container(
// // // //       padding: const EdgeInsets.all(10),
// // // //       decoration: BoxDecoration(
// // // //         color: const Color(0xFFFFFFFF),
// // // //         borderRadius: BorderRadius.circular(8),
// // // //         border: Border.all(color: const Color(0xFFE0E0E0)),
// // // //       ),
// // // //       child: Column(
// // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // //         children: [
// // // //           Text(
// // // //             title,
// // // //             style: const TextStyle(
// // // //               fontWeight: FontWeight.w600,
// // // //               fontSize: 12,
// // // //             ),
// // // //           ),
// // // //           const SizedBox(height: 4),
// // // //           Text(
// // // //             description,
// // // //             style: const TextStyle(
// // // //               fontSize: 11,
// // // //               color: Colors.black54,
// // // //               height: 1.3,
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   // -----------------------------
// // // //   // 화면 전체 빌드
// // // //   // -----------------------------
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: const Text('Study Highlight PDF'),
// // // //         centerTitle: true,
// // // //         bottom: _buildTopToolbar(),
// // // //       ),
// // // //       body: Row(
// // // //         children: [
// // // //           // 왼쪽: PDF + 드로잉 (메인 작업 영역)
// // // //           Expanded(
// // // //             child: Stack(
// // // //               children: [
// // // //                 // PDF
// // // //                 Positioned.fill(
// // // //                   child: PDFView(
// // // //                     filePath: widget.path,
// // // //                     enableSwipe: true,
// // // //                     swipeHorizontal: true,
// // // //                     autoSpacing: true,
// // // //                     pageFling: true,
// // // //                     onRender: (pages) {
// // // //                       setState(() {
// // // //                         _totalPages = pages ?? 0;
// // // //                       });
// // // //                     },
// // // //                     onPageChanged: (page, total) {
// // // //                       setState(() {
// // // //                         _currentPage = page ?? 0;
// // // //                       });
// // // //                     },
// // // //                   ),
// // // //                 ),
// // // //                 // 드로잉 레이어
// // // //                 Positioned.fill(
// // // //                   child: RepaintBoundary(
// // // //                     key: _canvasKey, // key를 여기로 올려서 실제 캔버스 영역에 박음
// // // //                     child: GestureDetector(
// // // //                       behavior: HitTestBehavior.translucent,
// // // //                       onPanStart: _onPanStart,
// // // //                       onPanUpdate: _onPanUpdate,
// // // //                       onPanEnd: _onPanEnd,
// // // //                       child: CustomPaint(
// // // //                         painter: DrawingPainter(_strokes),
// // // //                         // 사이즈를 강제로 Expanded 영역 전체로
// // // //                         size: Size.infinite,
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //
// // // //           // 오른쪽: AI 패널
// // // //           _buildRightAiPanel(),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // //
// // // import 'package:flutter/material.dart';
// // // import 'package:file_picker/file_picker.dart';
// // // import 'package:flutter_pdfview/flutter_pdfview.dart';
// // // import 'package:flutter_pdf_text/flutter_pdf_text.dart';
// // // import 'package:flutter/services.dart';
// // //
// // // void main() {
// // //   runApp(const StudyHighlightApp());
// // // }
// // //
// // // class StudyHighlightApp extends StatelessWidget {
// // //   const StudyHighlightApp({super.key});
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return MaterialApp(
// // //       title: 'Study Highlight',
// // //       debugShowCheckedModeBanner: false,
// // //       home: const StudyHomePage(),
// // //     );
// // //   }
// // // }
// // //
// // // /// 홈 화면: PDF 선택
// // // class StudyHomePage extends StatelessWidget {
// // //   const StudyHomePage({super.key});
// // //
// // //   Future<void> _openPdf(BuildContext context) async {
// // //     final result = await FilePicker.platform.pickFiles(
// // //       type: FileType.custom,
// // //       allowedExtensions: ['pdf'],
// // //     );
// // //
// // //     if (result == null || result.files.single.path == null) return;
// // //
// // //     final path = result.files.single.path!;
// // //
// // //     Navigator.of(context).push(
// // //       MaterialPageRoute(builder: (_) => PDFDrawScreen(path: path)),
// // //     );
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: const Color(0xFFF5F5F5),
// // //       appBar: AppBar(
// // //         title: const Text('Study Highlight 노트'),
// // //         centerTitle: true,
// // //       ),
// // //       body: Center(
// // //         child: Column(
// // //           mainAxisSize: MainAxisSize.min,
// // //           children: [
// // //             const Icon(Icons.note_alt_outlined, size: 80),
// // //             const SizedBox(height: 16),
// // //             const Text(
// // //               'PDF를 선택해서 공부를 시작하세요.',
// // //               style: TextStyle(fontSize: 16),
// // //             ),
// // //             const SizedBox(height: 24),
// // //             ElevatedButton(
// // //               onPressed: () => _openPdf(context),
// // //               child: const Text('PDF 열기'),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // // -----------------------------
// // // // PDF 텍스트 추출용 리포지토리
// // // // -----------------------------
// // //
// // // class PdfTextRepository {
// // //   PDFDoc? _doc;
// // //   final Map<int, String> _pageTextCache = {};
// // //
// // //   Future<void> load(String path) async {
// // //     _doc = await PDFDoc.fromPath(path);
// // //   }
// // //
// // //   Future<String> getPageText(int pageIndex) async {
// // //     final doc = _doc;
// // //     if (doc == null) {
// // //       throw Exception('PDF 텍스트 문서를 아직 로드하지 않았습니다.');
// // //     }
// // //
// // //     if (_pageTextCache.containsKey(pageIndex)) {
// // //       return _pageTextCache[pageIndex]!;
// // //     }
// // //
// // //     // pdf_text는 1-based 페이지 인덱스 사용
// // //     final page = await doc.pageAt(pageIndex + 1);
// // //     final text = await page.text;
// // //     _pageTextCache[pageIndex] = text;
// // //     return text;
// // //   }
// // // }
// // //
// // // // -----------------------------
// // // // 드로잉 관련 모델
// // // // -----------------------------
// // //
// // // enum DrawTool {
// // //   pen,
// // //   highlighter,
// // //   eraser,
// // // }
// // //
// // // class Stroke {
// // //   Stroke({
// // //     required this.points,
// // //     required this.color,
// // //     required this.width,
// // //     required this.tool,
// // //   });
// // //
// // //   final List<Offset> points;
// // //   final Color color;
// // //   final double width;
// // //   final DrawTool tool;
// // // }
// // //
// // // /// 형광펜 Stroke를 기반으로 만든 "하이라이트 영역"
// // // class HighlightRegion {
// // //   HighlightRegion({
// // //     required this.page,
// // //     required this.rectNormalized,
// // //     required this.color,
// // //   });
// // //
// // //   final int page; // 0 기반 현재 페이지
// // //   final Rect rectNormalized; // 0~1 로 정규화된 좌표
// // //   final Color color;
// // //
// // //   Map<String, dynamic> toJson() {
// // //     return {
// // //       'page': page,
// // //       'rect': {
// // //         'left': rectNormalized.left,
// // //         'top': rectNormalized.top,
// // //         'right': rectNormalized.right,
// // //         'bottom': rectNormalized.bottom,
// // //       },
// // //       'color': color.value.toRadixString(16),
// // //     };
// // //   }
// // //
// // //   @override
// // //   String toString() => toJson().toString();
// // // }
// // //
// // // /// 한 줄(or 블록)에 해당하는 텍스트와 그 위치 정보
// // // class TextRegion {
// // //   final Rect rectNormalized; // 0~1 기준
// // //   final String text;
// // //
// // //   TextRegion({
// // //     required this.rectNormalized,
// // //     required this.text,
// // //   });
// // // }
// // //
// // // /// 페이지 텍스트를 TextRegion 리스트로 바꿔주는 헬퍼
// // // /// (지금은 단순히 줄 개수 기준으로 페이지를 나누는 1차 버전)
// // // class PageTextLayoutService {
// // //   List<TextRegion> buildRegions({
// // //     required String pageText,
// // //     required Size pageSize,
// // //   }) {
// // //     final lines = pageText.split('\n');
// // //     final regions = <TextRegion>[];
// // //
// // //     if (lines.isEmpty || pageSize.height <= 0) {
// // //       return regions;
// // //     }
// // //
// // //     final lineCount = lines.length;
// // //     final lineHeight = pageSize.height / lineCount;
// // //
// // //     for (var i = 0; i < lineCount; i++) {
// // //       final text = lines[i].trim();
// // //       if (text.isEmpty) continue;
// // //
// // //       final top = i * lineHeight;
// // //       final rect = Rect.fromLTWH(0, top, pageSize.width, lineHeight);
// // //
// // //       final rectNormalized = Rect.fromLTWH(
// // //         rect.left / pageSize.width,
// // //         rect.top / pageSize.height,
// // //         rect.width / pageSize.width,
// // //         rect.height / pageSize.height,
// // //       );
// // //
// // //       regions.add(
// // //         TextRegion(
// // //           rectNormalized: rectNormalized,
// // //           text: text,
// // //         ),
// // //       );
// // //     }
// // //
// // //     return regions;
// // //   }
// // // }
// // //
// // // // -----------------------------
// // // // Stroke 리스트를 그리는 Painter
// // // // -----------------------------
// // //
// // // class DrawingPainter extends CustomPainter {
// // //   final List<Stroke> strokes;
// // //
// // //   DrawingPainter(this.strokes);
// // //
// // //   @override
// // //   void paint(Canvas canvas, Size size) {
// // //     for (final stroke in strokes) {
// // //       if (stroke.points.length < 2) continue;
// // //
// // //       final paint = Paint()
// // //         ..color = (stroke.tool == DrawTool.highlighter)
// // //             ? stroke.color.withOpacity(0.7)
// // //             : stroke.color
// // //         ..strokeWidth = stroke.width
// // //         ..strokeCap = StrokeCap.round
// // //         ..strokeJoin = StrokeJoin.round
// // //         ..style = PaintingStyle.stroke;
// // //
// // //       for (int i = 0; i < stroke.points.length - 1; i++) {
// // //         final p1 = stroke.points[i];
// // //         final p2 = stroke.points[i + 1];
// // //         canvas.drawLine(p1, p2, paint);
// // //       }
// // //     }
// // //   }
// // //
// // //   @override
// // //   bool shouldRepaint(covariant DrawingPainter oldDelegate) {
// // //     return true;
// // //   }
// // // }
// // //
// // // // -----------------------------
// // // // PDF + 드로잉 + 상단 툴바 + 오른쪽 AI 패널 화면
// // // // -----------------------------
// // //
// // // class PDFDrawScreen extends StatefulWidget {
// // //   final String path;
// // //   const PDFDrawScreen({super.key, required this.path});
// // //
// // //   @override
// // //   State<PDFDrawScreen> createState() => _PDFDrawScreenState();
// // // }
// // //
// // // class _PDFDrawScreenState extends State<PDFDrawScreen> {
// // //   final List<Stroke> _strokes = [];
// // //   final List<Stroke> _redoStack = [];
// // //
// // //   Stroke? _currentStroke;
// // //
// // //   // 현재 도구/색상/두께
// // //   DrawTool _tool = DrawTool.highlighter;
// // //   Color _currentColor = Colors.yellowAccent;
// // //   double _currentWidth = 16.0;
// // //
// // //   // PDF 페이지 상태
// // //   int _currentPage = 0;
// // //   int _totalPages = 0;
// // //
// // //   // 형광펜 하이라이트 영역 리스트
// // //   final List<HighlightRegion> _highlights = [];
// // //
// // //   // 캔버스 영역 기준 좌표 변환용 키
// // //   final GlobalKey _canvasKey = GlobalKey();
// // //
// // //   // PDF 텍스트 및 레이아웃 캐시
// // //   final PdfTextRepository _pdfTextRepository = PdfTextRepository();
// // //   final PageTextLayoutService _pageTextLayoutService = PageTextLayoutService();
// // //   final Map<int, List<TextRegion>> _pageRegionsCache = {}; // pageIndex → regions
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _initPdfText();
// // //   }
// // //
// // //   Future<void> _initPdfText() async {
// // //     try {
// // //       await _pdfTextRepository.load(widget.path);
// // //       debugPrint('PDF 텍스트 로드 완료');
// // //     } catch (e) {
// // //       debugPrint('PDF 텍스트 로드 실패: $e');
// // //     }
// // //   }
// // //
// // //   // -----------------------------
// // //   // 헬퍼: 색상 → 태그 레이블
// // //   // -----------------------------
// // //   String get _currentTagLabel {
// // //     if (_currentColor.value == Colors.yellowAccent.value) {
// // //       return '복습(Review)';
// // //     } else if (_currentColor.value == Colors.lightBlueAccent.value) {
// // //       return '심화(Deep)';
// // //     } else if (_currentColor.value == Colors.pinkAccent.value) {
// // //       return '예제(Example)';
// // //     } else if (_currentColor.value == Colors.greenAccent.value) {
// // //       return '정리(Summary)';
// // //     } else if (_currentColor.value == Colors.orangeAccent.value) {
// // //       return '기타(Custom)';
// // //     } else {
// // //       return '태그 미지정';
// // //     }
// // //   }
// // //
// // //   // -----------------------------
// // //   // 드로잉 로직
// // //   // -----------------------------
// // //
// // //   Offset _toLocal(Offset globalPosition) {
// // //     final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
// // //     if (box == null) return globalPosition;
// // //     return box.globalToLocal(globalPosition);
// // //   }
// // //
// // //   void _onPanStart(DragStartDetails details) {
// // //     final pos = _toLocal(details.globalPosition);
// // //
// // //     // 지우개 모드: Stroke 제거
// // //     if (_tool == DrawTool.eraser) {
// // //       _eraseAt(pos);
// // //       return;
// // //     }
// // //
// // //     final width = (_tool == DrawTool.highlighter)
// // //         ? _currentWidth
// // //         : (_currentWidth / 1.8).clamp(2.0, 12.0);
// // //
// // //     _currentStroke = Stroke(
// // //       points: [pos],
// // //       color: _currentColor,
// // //       width: width,
// // //       tool: _tool,
// // //     );
// // //
// // //     setState(() {
// // //       _strokes.add(_currentStroke!);
// // //       _redoStack.clear();
// // //     });
// // //   }
// // //
// // //   void _onPanUpdate(DragUpdateDetails details) {
// // //     final pos = _toLocal(details.globalPosition);
// // //
// // //     if (_tool == DrawTool.eraser) {
// // //       _eraseAt(pos);
// // //       return;
// // //     }
// // //
// // //     if (_currentStroke == null) return;
// // //
// // //     setState(() {
// // //       _currentStroke!.points.add(pos);
// // //     });
// // //   }
// // //
// // //   void _onPanEnd(DragEndDetails details) {
// // //     if (_currentStroke != null && _currentStroke!.tool == DrawTool.highlighter) {
// // //       _saveHighlightFromStroke(_currentStroke!);
// // //     }
// // //     _currentStroke = null;
// // //   }
// // //
// // //   // Stroke → HighlightRegion 변환
// // //   void _saveHighlightFromStroke(Stroke stroke) {
// // //     if (stroke.points.length < 2) return;
// // //
// // //     final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
// // //     if (box == null) return;
// // //
// // //     final size = box.size;
// // //
// // //     double minX = stroke.points.first.dx;
// // //     double maxX = stroke.points.first.dx;
// // //     double minY = stroke.points.first.dy;
// // //     double maxY = stroke.points.first.dy;
// // //
// // //     for (final p in stroke.points) {
// // //       if (p.dx < minX) minX = p.dx;
// // //       if (p.dx > maxX) maxX = p.dx;
// // //       if (p.dy < minY) minY = p.dy;
// // //       if (p.dy > maxY) maxY = p.dy;
// // //     }
// // //
// // //     const padding = 4.0;
// // //     minX = (minX - padding).clamp(0.0, size.width);
// // //     maxX = (maxX + padding).clamp(0.0, size.width);
// // //     minY = (minY - padding).clamp(0.0, size.height);
// // //     maxY = (maxY + padding).clamp(0.0, size.height);
// // //
// // //     final rect = Rect.fromLTRB(minX, minY, maxX, maxY);
// // //
// // //     final normalized = Rect.fromLTRB(
// // //       rect.left / size.width,
// // //       rect.top / size.height,
// // //       rect.right / size.width,
// // //       rect.bottom / size.height,
// // //     );
// // //
// // //     final region = HighlightRegion(
// // //       page: _currentPage,
// // //       rectNormalized: normalized,
// // //       color: stroke.color,
// // //     );
// // //
// // //     setState(() {
// // //       _highlights.add(region);
// // //     });
// // //
// // //     debugPrint('New highlight: $region');
// // //   }
// // //
// // //   // 지우개: 현재 위치 근처에 있는 Stroke를 제거
// // //   void _eraseAt(Offset pos) {
// // //     const double threshold = 20.0;
// // //
// // //     setState(() {
// // //       _strokes.removeWhere((stroke) {
// // //         return stroke.points.any(
// // //           (p) => (p - pos).distance <= threshold,
// // //         );
// // //       });
// // //
// // //       _highlights.removeWhere((region) {
// // //         final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
// // //         if (box == null) return false;
// // //         final size = box.size;
// // //
// // //         final rect = Rect.fromLTRB(
// // //           region.rectNormalized.left * size.width,
// // //           region.rectNormalized.top * size.height,
// // //           region.rectNormalized.right * size.width,
// // //           region.rectNormalized.bottom * size.height,
// // //         );
// // //         final center = rect.center;
// // //         return (center - pos).distance <= threshold;
// // //       });
// // //     });
// // //   }
// // //
// // //   // Undo / Redo / Clear
// // //   void _undo() {
// // //     if (_strokes.isEmpty) return;
// // //     setState(() {
// // //       final last = _strokes.removeLast();
// // //       _redoStack.add(last);
// // //       if (_highlights.isNotEmpty) {
// // //         _highlights.removeLast();
// // //       }
// // //     });
// // //   }
// // //
// // //   void _redo() {
// // //     if (_redoStack.isEmpty) return;
// // //     setState(() {
// // //       final stroke = _redoStack.removeLast();
// // //       _strokes.add(stroke);
// // //     });
// // //   }
// // //
// // //   void _clearAll() {
// // //     setState(() {
// // //       _strokes.clear();
// // //       _redoStack.clear();
// // //       _highlights.clear();
// // //     });
// // //   }
// // //
// // //   // -----------------------------
// // //   // TextRegion 관련 헬퍼
// // //   // -----------------------------
// // //
// // //   Future<List<TextRegion>> _getRegionsForPage(int pageIndex) async {
// // //     if (_pageRegionsCache.containsKey(pageIndex)) {
// // //       return _pageRegionsCache[pageIndex]!;
// // //     }
// // //
// // //     final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
// // //     if (box == null) {
// // //       throw Exception('캔버스 RenderBox를 찾을 수 없습니다.');
// // //     }
// // //     final pageSize = box.size;
// // //
// // //     final pageText = await _pdfTextRepository.getPageText(pageIndex);
// // //
// // //     final regions = _pageTextLayoutService.buildRegions(
// // //       pageText: pageText,
// // //       pageSize: pageSize,
// // //     );
// // //
// // //     _pageRegionsCache[pageIndex] = regions;
// // //     return regions;
// // //   }
// // //
// // //   String _extractTextForHighlight({
// // //     required Rect highlightRectNormalized,
// // //     required List<TextRegion> regions,
// // //   }) {
// // //     final buffer = StringBuffer();
// // //
// // //     for (final region in regions) {
// // //       if (highlightRectNormalized.overlaps(region.rectNormalized)) {
// // //         buffer.writeln(region.text.trim());
// // //       }
// // //     }
// // //
// // //     return buffer.toString().trim();
// // //   }
// // //
// // //   /// 특정 색상의 하이라이트 텍스트를 전 페이지에서 모아서 하나의 문자열로 합치기
// // //   Future<String> _collectHighlightTextByColor(Color targetColor) async {
// // //     if (_highlights.isEmpty) {
// // //       return '';
// // //     }
// // //
// // //     final filtered = _highlights
// // //         .where((h) => h.color.value == targetColor.value)
// // //         .toList();
// // //
// // //     if (filtered.isEmpty) {
// // //       return '';
// // //     }
// // //
// // //     final buffer = StringBuffer();
// // //
// // //     final byPage = <int, List<HighlightRegion>>{};
// // //     for (final h in filtered) {
// // //       byPage.putIfAbsent(h.page, () => []).add(h);
// // //     }
// // //
// // //     for (final entry in byPage.entries) {
// // //       final pageIndex = entry.key;
// // //       final pageHighlights = entry.value;
// // //
// // //       final regions = await _getRegionsForPage(pageIndex);
// // //
// // //       buffer.writeln('===== Page ${pageIndex + 1} =====');
// // //
// // //       for (final h in pageHighlights) {
// // //         final text = _extractTextForHighlight(
// // //           highlightRectNormalized: h.rectNormalized,
// // //           regions: regions,
// // //         );
// // //
// // //         if (text.isNotEmpty) {
// // //           buffer.writeln(text);
// // //           buffer.writeln();
// // //         }
// // //       }
// // //
// // //       buffer.writeln();
// // //     }
// // //
// // //     return buffer.toString().trim();
// // //   }
// // //
// // //   // -----------------------------
// // //   // UI: 상단 툴바
// // //   // -----------------------------
// // //
// // //   Widget _buildToolButton({
// // //     required IconData icon,
// // //     required DrawTool tool,
// // //   }) {
// // //     final isSelected = _tool == tool;
// // //
// // //     return IconButton(
// // //       tooltip: tool == DrawTool.pen
// // //           ? '펜'
// // //           : tool == DrawTool.highlighter
// // //               ? '형광펜'
// // //               : '지우개',
// // //       icon: Icon(
// // //         icon,
// // //         color: isSelected ? Colors.blueAccent : Colors.black54,
// // //       ),
// // //       onPressed: () {
// // //         setState(() {
// // //           _tool = tool;
// // //         });
// // //       },
// // //     );
// // //   }
// // //
// // //   Widget _buildColorDot(Color color) {
// // //     final bool selected = _currentColor.value == color.value;
// // //
// // //     return GestureDetector(
// // //       onTap: () {
// // //         setState(() {
// // //           _currentColor = color;
// // //           if (_tool == DrawTool.eraser) {
// // //             _tool = DrawTool.highlighter;
// // //           }
// // //         });
// // //       },
// // //       child: Container(
// // //         margin: const EdgeInsets.symmetric(horizontal: 4),
// // //         width: selected ? 26 : 22,
// // //         height: selected ? 26 : 22,
// // //         decoration: BoxDecoration(
// // //           color: color,
// // //           shape: BoxShape.circle,
// // //           border: Border.all(
// // //             color: selected ? Colors.black87 : Colors.black26,
// // //             width: selected ? 2 : 1,
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   PreferredSizeWidget _buildTopToolbar() {
// // //     return PreferredSize(
// // //       preferredSize: const Size.fromHeight(72),
// // //       child: Container(
// // //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
// // //         decoration: const BoxDecoration(
// // //           color: Colors.white,
// // //           boxShadow: [
// // //             BoxShadow(
// // //               color: Colors.black12,
// // //               blurRadius: 4,
// // //               offset: Offset(0, 1),
// // //             ),
// // //           ],
// // //         ),
// // //         child: Column(
// // //           children: [
// // //             Row(
// // //               children: [
// // //                 IconButton(
// // //                   tooltip: '줌 (추후 구현 예정)',
// // //                   icon: const Icon(Icons.search),
// // //                   onPressed: () {
// // //                     ScaffoldMessenger.of(context).showSnackBar(
// // //                       const SnackBar(
// // //                         content: Text('줌 기능은 나중에 구현할 예정입니다.'),
// // //                         duration: Duration(seconds: 1),
// // //                       ),
// // //                     );
// // //                   },
// // //                 ),
// // //                 _buildToolButton(icon: Icons.edit, tool: DrawTool.pen),
// // //                 _buildToolButton(
// // //                     icon: Icons.border_color, tool: DrawTool.highlighter),
// // //                 _buildToolButton(
// // //                     icon: Icons.auto_fix_normal, tool: DrawTool.eraser),
// // //                 const SizedBox(width: 8),
// // //                 IconButton(
// // //                   tooltip: '선택 도구 (추후 구현 예정)',
// // //                   icon: const Icon(Icons.all_inclusive),
// // //                   onPressed: () {
// // //                     ScaffoldMessenger.of(context).showSnackBar(
// // //                       const SnackBar(
// // //                         content: Text('선택 도구는 나중에 구현할 예정입니다.'),
// // //                         duration: Duration(seconds: 1),
// // //                       ),
// // //                     );
// // //                   },
// // //                 ),
// // //                 IconButton(
// // //                   tooltip: '도형 (추후 구현 예정)',
// // //                   icon: const Icon(Icons.crop_square),
// // //                   onPressed: () {
// // //                     ScaffoldMessenger.of(context).showSnackBar(
// // //                       const SnackBar(
// // //                         content: Text('도형 기능은 나중에 구현할 예정입니다.'),
// // //                         duration: Duration(seconds: 1),
// // //                       ),
// // //                     );
// // //                   },
// // //                 ),
// // //                 const Spacer(),
// // //                 IconButton(
// // //                   tooltip: '되돌리기',
// // //                   icon: const Icon(Icons.undo),
// // //                   onPressed: _undo,
// // //                 ),
// // //                 IconButton(
// // //                   tooltip: '다시 실행',
// // //                   icon: const Icon(Icons.redo),
// // //                   onPressed: _redo,
// // //                 ),
// // //                 IconButton(
// // //                   tooltip: '전체 지우기',
// // //                   icon: const Icon(Icons.delete_outline),
// // //                   onPressed: _clearAll,
// // //                 ),
// // //               ],
// // //             ),
// // //             Row(
// // //               children: [
// // //                 _buildColorDot(Colors.yellowAccent),
// // //                 _buildColorDot(Colors.lightBlueAccent),
// // //                 _buildColorDot(Colors.pinkAccent),
// // //                 _buildColorDot(Colors.greenAccent),
// // //                 _buildColorDot(Colors.orangeAccent),
// // //                 const SizedBox(width: 12),
// // //                 const Text(
// // //                   '두께',
// // //                   style: TextStyle(fontSize: 12),
// // //                 ),
// // //                 Expanded(
// // //                   child: Slider(
// // //                     value: _currentWidth,
// // //                     min: 4,
// // //                     max: 28,
// // //                     divisions: 12,
// // //                     onChanged: (value) {
// // //                       setState(() {
// // //                         _currentWidth = value;
// // //                       });
// // //                     },
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   // -----------------------------
// // //   // 오른쪽 AI 패널 UI
// // //   // -----------------------------
// // //
// // //   Widget _buildRightAiPanel() {
// // //     final currentPageHighlights =
// // //         _highlights.where((h) => h.page == _currentPage).toList();
// // //
// // //     return Container(
// // //       width: 320,
// // //       decoration: const BoxDecoration(
// // //         color: Color(0xFFF7F8FA),
// // //         border: Border(
// // //           left: BorderSide(color: Color(0xFFDDDDDD)),
// // //         ),
// // //       ),
// // //       child: Column(
// // //         children: [
// // //           Container(
// // //             padding:
// // //                 const EdgeInsets.only(top: 12, bottom: 8, left: 16, right: 16),
// // //             decoration: const BoxDecoration(
// // //               color: Colors.white,
// // //               boxShadow: [
// // //                 BoxShadow(
// // //                   color: Colors.black12,
// // //                   blurRadius: 3,
// // //                   offset: Offset(0, 1),
// // //                 ),
// // //               ],
// // //             ),
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 const Text(
// // //                   'AI 학습 패널',
// // //                   style: TextStyle(
// // //                     fontWeight: FontWeight.bold,
// // //                     fontSize: 16,
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 6),
// // //                 Row(
// // //                   children: [
// // //                     Container(
// // //                       width: 10,
// // //                       height: 10,
// // //                       margin: const EdgeInsets.only(right: 6),
// // //                       decoration: BoxDecoration(
// // //                         color: _currentColor,
// // //                         shape: BoxShape.circle,
// // //                         border: Border.all(color: Colors.black26),
// // //                       ),
// // //                     ),
// // //                     Expanded(
// // //                       child: Text(
// // //                         '현재 태그: $_currentTagLabel',
// // //                         style: const TextStyle(
// // //                           fontSize: 12,
// // //                           color: Colors.black87,
// // //                         ),
// // //                         overflow: TextOverflow.ellipsis,
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //                 const SizedBox(height: 4),
// // //                 Text(
// // //                   '현재 페이지: ${_currentPage + 1} / $_totalPages, '
// // //                   '하이라이트 ${currentPageHighlights.length}개',
// // //                   style: const TextStyle(
// // //                     fontSize: 11,
// // //                     color: Colors.black54,
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           Expanded(
// // //             child: Padding(
// // //               padding:
// // //                   const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
// // //               child: ListView(
// // //                 children: [
// // //                   const SizedBox(height: 8),
// // //                   const Text(
// // //                     '하이라이트 좌표 (디버그 용)',
// // //                     style: TextStyle(
// // //                       fontWeight: FontWeight.w600,
// // //                       fontSize: 13,
// // //                     ),
// // //                   ),
// // //                   const SizedBox(height: 6),
// // //                   if (currentPageHighlights.isEmpty)
// // //                     Container(
// // //                       padding: const EdgeInsets.all(10),
// // //                       decoration: BoxDecoration(
// // //                         color: Colors.white,
// // //                         borderRadius: BorderRadius.circular(8),
// // //                         border: Border.all(color: Color(0xFFDDDDDD)),
// // //                       ),
// // //                       child: const Text(
// // //                         '이 페이지에서 형광펜으로 문장을 긋고 나면, '
// // //                         '정규화된 좌표 정보가 여기에 표시됩니다.',
// // //                         style: TextStyle(fontSize: 12, height: 1.4),
// // //                       ),
// // //                     )
// // //                   else
// // //                     ...currentPageHighlights.map((h) {
// // //                       final r = h.rectNormalized;
// // //                       return Container(
// // //                         margin: const EdgeInsets.only(bottom: 6),
// // //                         padding: const EdgeInsets.all(8),
// // //                         decoration: BoxDecoration(
// // //                           color: Colors.white,
// // //                           borderRadius: BorderRadius.circular(6),
// // //                           border: Border.all(color: Color(0xFFE0E0E0)),
// // //                         ),
// // //                         child: Text(
// // //                           'page=${h.page}, '
// // //                           'left=${r.left.toStringAsFixed(3)}, '
// // //                           'top=${r.top.toStringAsFixed(3)}, '
// // //                           'right=${r.right.toStringAsFixed(3)}, '
// // //                           'bottom=${r.bottom.toStringAsFixed(3)}',
// // //                           style: const TextStyle(
// // //                             fontSize: 11,
// // //                             height: 1.3,
// // //                           ),
// // //                         ),
// // //                       );
// // //                     }),
// // //                   const SizedBox(height: 16),
// // //                   const Text(
// // //                     'AI 작업 히스토리 (향후)',
// // //                     style: TextStyle(
// // //                       fontWeight: FontWeight.w600,
// // //                       fontSize: 13,
// // //                     ),
// // //                   ),
// // //                   const SizedBox(height: 6),
// // //                   _buildHistoryPlaceholder(
// // //                     title: '복습 요약',
// // //                     description: '노랑 태그로 긋는 구간이 여기에 쌓일 예정입니다.',
// // //                   ),
// // //                   const SizedBox(height: 8),
// // //                   _buildHistoryPlaceholder(
// // //                     title: '심화 설명',
// // //                     description: '하늘 태그로 긋는 구간의 심화 설명이 저장됩니다.',
// // //                   ),
// // //                   const SizedBox(height: 8),
// // //                   _buildHistoryPlaceholder(
// // //                     title: '예제/문제',
// // //                     description: '예제 태그를 기반으로 자동 문제가 생성됩니다.',
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ),
// // //           Container(
// // //             padding:
// // //                 const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
// // //             decoration: const BoxDecoration(
// // //               color: Colors.white,
// // //               border: Border(
// // //                 top: BorderSide(color: Color(0xFFDDDDDD)),
// // //               ),
// // //             ),
// // //             child: Column(
// // //               children: [
// // //                 SizedBox(
// // //                   width: double.infinity,
// // //                   child: ElevatedButton.icon(
// // //                     icon: const Icon(Icons.code, size: 18),
// // //                     label: const Text(
// // //                       '하이라이트 JSON 로그',
// // //                       style: TextStyle(fontSize: 13),
// // //                     ),
// // //                     onPressed: () {
// // //                       for (final h in _highlights) {
// // //                         debugPrint(h.toString());
// // //                       }
// // //                       ScaffoldMessenger.of(context).showSnackBar(
// // //                         const SnackBar(
// // //                           content: Text('디버그 콘솔에서 하이라이트 정보를 확인할 수 있습니다.'),
// // //                           duration: Duration(seconds: 1),
// // //                         ),
// // //                       );
// // //                     },
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 6),
// // //                 SizedBox(
// // //                   width: double.infinity,
// // //                   child: ElevatedButton.icon(
// // //                     icon: const Icon(Icons.highlight, size: 18),
// // //                     label: const Text(
// // //                       '노랑 하이라이트 텍스트 보기',
// // //                       style: TextStyle(fontSize: 13),
// // //                     ),
// // //                     onPressed: () async {
// // //                       try {
// // //                         final result = await _collectHighlightTextByColor(
// // //                           Colors.yellowAccent,
// // //                         );
// // //
// // //                         if (!mounted) return;
// // //
// // //                         if (result.isEmpty) {
// // //                           ScaffoldMessenger.of(context).showSnackBar(
// // //                             const SnackBar(
// // //                               content: Text('노랑 하이라이트에 매핑된 텍스트가 없습니다.'),
// // //                               duration: Duration(seconds: 1),
// // //                             ),
// // //                           );
// // //                           return;
// // //                         }
// // //
// // //                         await showDialog(
// // //                           context: context,
// // //                           builder: (context) {
// // //                             return AlertDialog(
// // //                               title: const Text('노랑 하이라이트 텍스트'),
// // //                               content: SizedBox(
// // //                                 width: double.maxFinite,
// // //                                 child: SingleChildScrollView(
// // //                                   child: Text(
// // //                                     result,
// // //                                     style: const TextStyle(
// // //                                       fontSize: 13,
// // //                                       height: 1.4,
// // //                                     ),
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                               actions: [
// // //                                 TextButton(
// // //                                   onPressed: () =>
// // //                                       Navigator.of(context).pop(),
// // //                                   child: const Text('닫기'),
// // //                                 ),
// // //                               ],
// // //                             );
// // //                           },
// // //                         );
// // //                       } catch (e) {
// // //                         if (!mounted) return;
// // //                         ScaffoldMessenger.of(context).showSnackBar(
// // //                           SnackBar(
// // //                             content: Text('텍스트 추출 중 오류가 발생했습니다: $e'),
// // //                             duration: const Duration(seconds: 2),
// // //                           ),
// // //                         );
// // //                       }
// // //                     },
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 6),
// // //                 SizedBox(
// // //                   width: double.infinity,
// // //                   child: OutlinedButton(
// // //                     child: const Text(
// // //                       '전체 복습 콘텐츠 보기 (향후)',
// // //                       style: TextStyle(fontSize: 12),
// // //                     ),
// // //                     onPressed: () {
// // //                       ScaffoldMessenger.of(context).showSnackBar(
// // //                         const SnackBar(
// // //                           content: Text('복습 콘텐츠 화면은 추후 구현 예정입니다.'),
// // //                           duration: Duration(seconds: 1),
// // //                         ),
// // //                       );
// // //                     },
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   static Widget _buildHistoryPlaceholder({
// // //     required String title,
// // //     required String description,
// // //   }) {
// // //     return Container(
// // //       padding: const EdgeInsets.all(10),
// // //       decoration: BoxDecoration(
// // //         color: const Color(0xFFFFFFFF),
// // //         borderRadius: BorderRadius.circular(8),
// // //         border: Border.all(color: Color(0xFFE0E0E0)),
// // //       ),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Text(
// // //             title,
// // //             style: const TextStyle(
// // //               fontWeight: FontWeight.w600,
// // //               fontSize: 12,
// // //             ),
// // //           ),
// // //           const SizedBox(height: 4),
// // //           Text(
// // //             description,
// // //             style: const TextStyle(
// // //               fontSize: 11,
// // //               color: Colors.black54,
// // //               height: 1.3,
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   // -----------------------------
// // //   // 화면 전체 빌드
// // //   // -----------------------------
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text('Study Highlight PDF'),
// // //         centerTitle: true,
// // //         bottom: _buildTopToolbar(),
// // //       ),
// // //       body: Row(
// // //         children: [
// // //           Expanded(
// // //             child: Stack(
// // //               children: [
// // //                 Positioned.fill(
// // //                   child: PDFView(
// // //                     filePath: widget.path,
// // //                     enableSwipe: true,
// // //                     swipeHorizontal: true,
// // //                     autoSpacing: true,
// // //                     pageFling: true,
// // //                     onRender: (pages) {
// // //                       setState(() {
// // //                         _totalPages = pages ?? 0;
// // //                       });
// // //                     },
// // //                     onPageChanged: (page, total) {
// // //                       setState(() {
// // //                         _currentPage = page ?? 0;
// // //                       });
// // //                     },
// // //                   ),
// // //                 ),
// // //                 Positioned.fill(
// // //                   child: RepaintBoundary(
// // //                     key: _canvasKey,
// // //                     child: GestureDetector(
// // //                       behavior: HitTestBehavior.translucent,
// // //                       onPanStart: _onPanStart,
// // //                       onPanUpdate: _onPanUpdate,
// // //                       onPanEnd: _onPanEnd,
// // //                       child: CustomPaint(
// // //                         painter: DrawingPainter(_strokes),
// // //                         size: Size.infinite,
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           _buildRightAiPanel(),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
// //
// //
// // import 'package:flutter/material.dart';
// // import 'package:file_picker/file_picker.dart';
// // import 'package:flutter_pdfview/flutter_pdfview.dart';
// // import 'package:flutter_pdf_text/flutter_pdf_text.dart';
// // import 'package:flutter/services.dart'; // Clipboard 사용
// //
// // void main() {
// //   runApp(const StudyHighlightApp());
// // }
// //
// // class StudyHighlightApp extends StatelessWidget {
// //   const StudyHighlightApp({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Study Highlight',
// //       debugShowCheckedModeBanner: false,
// //       home: const StudyHomePage(),
// //     );
// //   }
// // }
// //
// // /// 홈 화면: PDF 선택
// // class StudyHomePage extends StatelessWidget {
// //   const StudyHomePage({super.key});
// //
// //   Future<void> _openPdf(BuildContext context) async {
// //     final result = await FilePicker.platform.pickFiles(
// //       type: FileType.custom,
// //       allowedExtensions: ['pdf'],
// //     );
// //
// //     if (result == null || result.files.single.path == null) return;
// //
// //     final path = result.files.single.path!;
// //
// //     Navigator.of(context).push(
// //       MaterialPageRoute(builder: (_) => PDFDrawScreen(path: path)),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF5F5F5),
// //       appBar: AppBar(
// //         title: const Text('Study Highlight 노트'),
// //         centerTitle: true,
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             const Icon(Icons.note_alt_outlined, size: 80),
// //             const SizedBox(height: 16),
// //             const Text(
// //               'PDF를 선택해서 공부를 시작하세요.',
// //               style: TextStyle(fontSize: 16),
// //             ),
// //             const SizedBox(height: 24),
// //             ElevatedButton(
// //               onPressed: () => _openPdf(context),
// //               child: const Text('PDF 열기'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // // -----------------------------
// // // PDF 텍스트 추출용 리포지토리
// // // -----------------------------
// //
// // class PdfTextRepository {
// //   PDFDoc? _doc;
// //   final Map<int, String> _pageTextCache = {};
// //
// //   Future<void> load(String path) async {
// //     _doc = await PDFDoc.fromPath(path);
// //   }
// //
// //   Future<String> getPageText(int pageIndex) async {
// //     final doc = _doc;
// //     if (doc == null) {
// //       throw Exception('PDF 텍스트 문서를 아직 로드하지 않았습니다.');
// //     }
// //
// //     if (_pageTextCache.containsKey(pageIndex)) {
// //       return _pageTextCache[pageIndex]!;
// //     }
// //
// //     // flutter_pdf_text는 1-based 페이지 인덱스 사용
// //     final page = await doc.pageAt(pageIndex + 1);
// //     final text = await page.text;
// //     _pageTextCache[pageIndex] = text;
// //     return text;
// //   }
// // }
// //
// // // -----------------------------
// // // 드로잉 관련 모델
// // // -----------------------------
// //
// // enum DrawTool {
// //   pen,
// //   highlighter,
// //   eraser,
// // }
// //
// // class Stroke {
// //   Stroke({
// //     required this.points,
// //     required this.color,
// //     required this.width,
// //     required this.tool,
// //   });
// //
// //   final List<Offset> points;
// //   final Color color;
// //   final double width;
// //   final DrawTool tool;
// // }
// //
// // /// 형광펜 Stroke를 기반으로 만든 "하이라이트 영역"
// // class HighlightRegion {
// //   HighlightRegion({
// //     required this.page,
// //     required this.rectNormalized,
// //     required this.color,
// //   });
// //
// //   final int page; // 0 기반 현재 페이지
// //   final Rect rectNormalized; // 0~1 로 정규화된 좌표
// //   final Color color;
// //
// //   Map<String, dynamic> toJson() {
// //     return {
// //       'page': page,
// //       'rect': {
// //         'left': rectNormalized.left,
// //         'top': rectNormalized.top,
// //         'right': rectNormalized.right,
// //         'bottom': rectNormalized.bottom,
// //       },
// //       'color': color.value.toRadixString(16),
// //     };
// //   }
// //
// //   @override
// //   String toString() => toJson().toString();
// // }
// //
// // /// 한 줄(or 블록)에 해당하는 텍스트와 그 위치 정보
// // class TextRegion {
// //   final Rect rectNormalized; // 0~1 기준
// //   final String text;
// //
// //   TextRegion({
// //     required this.rectNormalized,
// //     required this.text,
// //   });
// // }
// //
// // /// 페이지 텍스트를 TextRegion 리스트로 바꿔주는 헬퍼
// // /// 헤더/푸터 여백을 조금 빼고 가운데 영역만 텍스트로 사용 (대략 보정용)
// // class PageTextLayoutService {
// //   List<TextRegion> buildRegions({
// //     required String pageText,
// //     required Size pageSize,
// //   }) {
// //     final lines = pageText.split('\n');
// //     final regions = <TextRegion>[];
// //
// //     if (lines.isEmpty || pageSize.height <= 0) {
// //       return regions;
// //     }
// //
// //     // 화면 상단/하단 여백 비율 (필요하면 숫자 조금씩 바꿔보면 됨)
// //     const topMarginRatio = 0.22;   // 위쪽 22%는 제목/여백으로 간주
// //     const bottomMarginRatio = 0.06; // 아래쪽 6%는 여백으로 간주
// //
// //     final usableHeight =
// //         pageSize.height * (1 - topMarginRatio - bottomMarginRatio);
// //     final startY = pageSize.height * topMarginRatio;
// //
// //     final lineCount = lines.length;
// //     final lineHeight =
// //         lineCount > 0 ? usableHeight / lineCount : usableHeight;
// //
// //     for (var i = 0; i < lineCount; i++) {
// //       final text = lines[i].trim();
// //       if (text.isEmpty) continue;
// //
// //       final top = startY + i * lineHeight;
// //       final rect = Rect.fromLTWH(0, top, pageSize.width, lineHeight);
// //
// //       final rectNormalized = Rect.fromLTWH(
// //         rect.left / pageSize.width,
// //         rect.top / pageSize.height,
// //         rect.width / pageSize.width,
// //         rect.height / pageSize.height,
// //       );
// //
// //       regions.add(
// //         TextRegion(
// //           rectNormalized: rectNormalized,
// //           text: text,
// //         ),
// //       );
// //     }
// //
// //     return regions;
// //   }
// // }
// //
// //
// // // -----------------------------
// // // Stroke 리스트를 그리는 Painter
// // // -----------------------------
// //
// // class DrawingPainter extends CustomPainter {
// //   final List<Stroke> strokes;
// //
// //   DrawingPainter(this.strokes);
// //
// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     for (final stroke in strokes) {
// //       if (stroke.points.length < 2) continue;
// //
// //       final paint = Paint()
// //         ..color = (stroke.tool == DrawTool.highlighter)
// //             ? stroke.color.withOpacity(0.7)
// //             : stroke.color
// //         ..strokeWidth = stroke.width
// //         ..strokeCap = StrokeCap.round
// //         ..strokeJoin = StrokeJoin.round
// //         ..style = PaintingStyle.stroke;
// //
// //       for (int i = 0; i < stroke.points.length - 1; i++) {
// //         final p1 = stroke.points[i];
// //         final p2 = stroke.points[i + 1];
// //         canvas.drawLine(p1, p2, paint);
// //       }
// //     }
// //   }
// //
// //   @override
// //   bool shouldRepaint(covariant DrawingPainter oldDelegate) {
// //     return true;
// //   }
// // }
// //
// // // -----------------------------
// // // PDF + 드로잉 + 상단 툴바 + 오른쪽 AI 패널 화면
// // // -----------------------------
// //
// // class PDFDrawScreen extends StatefulWidget {
// //   final String path;
// //   const PDFDrawScreen({super.key, required this.path});
// //
// //   @override
// //   State<PDFDrawScreen> createState() => _PDFDrawScreenState();
// // }
// //
// // class _PDFDrawScreenState extends State<PDFDrawScreen> {
// //   final List<Stroke> _strokes = [];
// //   final List<Stroke> _redoStack = [];
// //
// //   Stroke? _currentStroke;
// //
// //   // 현재 도구/색상/두께
// //   DrawTool _tool = DrawTool.highlighter;
// //   Color _currentColor = Colors.yellowAccent;
// //   double _currentWidth = 16.0;
// //
// //   // PDF 페이지 상태
// //   int _currentPage = 0;
// //   int _totalPages = 0;
// //
// //   // 형광펜 하이라이트 영역 리스트
// //   final List<HighlightRegion> _highlights = [];
// //
// //   // 캔버스 영역 기준 좌표 변환용 키
// //   final GlobalKey _canvasKey = GlobalKey();
// //
// //   // PDF 텍스트 및 레이아웃 캐시
// //   final PdfTextRepository _pdfTextRepository = PdfTextRepository();
// //   final PageTextLayoutService _pageTextLayoutService = PageTextLayoutService();
// //   final Map<int, List<TextRegion>> _pageRegionsCache = {}; // pageIndex → regions
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _initPdfText();
// //   }
// //
// //   Future<void> _initPdfText() async {
// //     try {
// //       await _pdfTextRepository.load(widget.path);
// //       debugPrint('PDF 텍스트 로드 완료');
// //     } catch (e) {
// //       debugPrint('PDF 텍스트 로드 실패: $e');
// //     }
// //   }
// //
// //   // -----------------------------
// //   // 헬퍼: 색상 → 태그 레이블
// //   // -----------------------------
// //
// //   String get _currentTagLabel {
// //     if (_currentColor.value == Colors.yellowAccent.value) {
// //       return '복습(Review)';
// //     } else if (_currentColor.value == Colors.lightBlueAccent.value) {
// //       return '심화(Deep)';
// //     } else if (_currentColor.value == Colors.pinkAccent.value) {
// //       return '예제(Example)';
// //     } else if (_currentColor.value == Colors.greenAccent.value) {
// //       return '정리(Summary)';
// //     } else if (_currentColor.value == Colors.orangeAccent.value) {
// //       return '기타(Custom)';
// //     } else {
// //       return '태그 미지정';
// //     }
// //   }
// //
// //   // -----------------------------
// //   // 드로잉 로직
// //   // -----------------------------
// //
// //   Offset _toLocal(Offset globalPosition) {
// //     final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
// //     if (box == null) return globalPosition;
// //     return box.globalToLocal(globalPosition);
// //   }
// //
// //   void _onPanStart(DragStartDetails details) {
// //     final pos = _toLocal(details.globalPosition);
// //
// //     // 지우개 모드: Stroke 제거
// //     if (_tool == DrawTool.eraser) {
// //       _eraseAt(pos);
// //       return;
// //     }
// //
// //     final width = (_tool == DrawTool.highlighter)
// //         ? _currentWidth
// //         : (_currentWidth / 1.8).clamp(2.0, 12.0);
// //
// //     _currentStroke = Stroke(
// //       points: [pos],
// //       color: _currentColor,
// //       width: width,
// //       tool: _tool,
// //     );
// //
// //     setState(() {
// //       _strokes.add(_currentStroke!);
// //       _redoStack.clear();
// //     });
// //   }
// //
// //   void _onPanUpdate(DragUpdateDetails details) {
// //     final pos = _toLocal(details.globalPosition);
// //
// //     if (_tool == DrawTool.eraser) {
// //       _eraseAt(pos);
// //       return;
// //     }
// //
// //     if (_currentStroke == null) return;
// //
// //     setState(() {
// //       _currentStroke!.points.add(pos);
// //     });
// //   }
// //
// //   void _onPanEnd(DragEndDetails details) {
// //     if (_currentStroke != null && _currentStroke!.tool == DrawTool.highlighter) {
// //       _saveHighlightFromStroke(_currentStroke!);
// //     }
// //     _currentStroke = null;
// //   }
// //
// //   // Stroke → HighlightRegion 변환
// //   void _saveHighlightFromStroke(Stroke stroke) {
// //     if (stroke.points.length < 2) return;
// //
// //     final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
// //     if (box == null) return;
// //
// //     final size = box.size;
// //
// //     double minX = stroke.points.first.dx;
// //     double maxX = stroke.points.first.dx;
// //     double minY = stroke.points.first.dy;
// //     double maxY = stroke.points.first.dy;
// //
// //     for (final p in stroke.points) {
// //       if (p.dx < minX) minX = p.dx;
// //       if (p.dx > maxX) maxX = p.dx;
// //       if (p.dy < minY) minY = p.dy;
// //       if (p.dy > maxY) maxY = p.dy;
// //     }
// //
// //     const padding = 4.0;
// //     minX = (minX - padding).clamp(0.0, size.width);
// //     maxX = (maxX + padding).clamp(0.0, size.width);
// //     minY = (minY - padding).clamp(0.0, size.height);
// //     maxY = (maxY + padding).clamp(0.0, size.height);
// //
// //     final rect = Rect.fromLTRB(minX, minY, maxX, maxY);
// //
// //     final normalized = Rect.fromLTRB(
// //       rect.left / size.width,
// //       rect.top / size.height,
// //       rect.right / size.width,
// //       rect.bottom / size.height,
// //     );
// //
// //     final region = HighlightRegion(
// //       page: _currentPage,
// //       rectNormalized: normalized,
// //       color: stroke.color,
// //     );
// //
// //     setState(() {
// //       _highlights.add(region);
// //     });
// //
// //     debugPrint('New highlight: $region');
// //   }
// //
// //   // 지우개: 현재 위치 근처에 있는 Stroke를 제거
// //   void _eraseAt(Offset pos) {
// //     const double threshold = 20.0;
// //
// //     setState(() {
// //       _strokes.removeWhere((stroke) {
// //         return stroke.points.any(
// //           (p) => (p - pos).distance <= threshold,
// //         );
// //       });
// //
// //       _highlights.removeWhere((region) {
// //         final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
// //         if (box == null) return false;
// //         final size = box.size;
// //
// //         final rect = Rect.fromLTRB(
// //           region.rectNormalized.left * size.width,
// //           region.rectNormalized.top * size.height,
// //           region.rectNormalized.right * size.width,
// //           region.rectNormalized.bottom * size.height,
// //         );
// //         final center = rect.center;
// //         return (center - pos).distance <= threshold;
// //       });
// //     });
// //   }
// //
// //   // Undo / Redo / Clear
// //   void _undo() {
// //     if (_strokes.isEmpty) return;
// //     setState(() {
// //       final last = _strokes.removeLast();
// //       _redoStack.add(last);
// //       if (_highlights.isNotEmpty) {
// //         _highlights.removeLast();
// //       }
// //     });
// //   }
// //
// //   void _redo() {
// //     if (_redoStack.isEmpty) return;
// //     setState(() {
// //       final stroke = _redoStack.removeLast();
// //       _strokes.add(stroke);
// //     });
// //   }
// //
// //   void _clearAll() {
// //     setState(() {
// //       _strokes.clear();
// //       _redoStack.clear();
// //       _highlights.clear();
// //     });
// //   }
// //
// //   // -----------------------------
// //   // TextRegion 관련 헬퍼
// //   // -----------------------------
// //
// //   Future<List<TextRegion>> _getRegionsForPage(int pageIndex) async {
// //     if (_pageRegionsCache.containsKey(pageIndex)) {
// //       return _pageRegionsCache[pageIndex]!;
// //     }
// //
// //     final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
// //     if (box == null) {
// //       throw Exception('캔버스 RenderBox를 찾을 수 없습니다.');
// //     }
// //     final pageSize = box.size;
// //
// //     final pageText = await _pdfTextRepository.getPageText(pageIndex);
// //
// //     final regions = _pageTextLayoutService.buildRegions(
// //       pageText: pageText,
// //       pageSize: pageSize,
// //     );
// //
// //     _pageRegionsCache[pageIndex] = regions;
// //     return regions;
// //   }
// //
// //   String _extractTextForHighlight({
// //     required Rect highlightRectNormalized,
// //     required List<TextRegion> regions,
// //   }) {
// //     final buffer = StringBuffer();
// //
// //     for (final region in regions) {
// //       if (highlightRectNormalized.overlaps(region.rectNormalized)) {
// //         buffer.writeln(region.text.trim());
// //       }
// //     }
// //
// //     return buffer.toString().trim();
// //   }
// //
// //   /// 특정 색상의 하이라이트 텍스트를 전 페이지에서 모아서 하나의 문자열로 합치기
// //   Future<String> _collectHighlightTextByColor(Color targetColor) async {
// //     if (_highlights.isEmpty) {
// //       return '';
// //     }
// //
// //     final filtered = _highlights
// //         .where((h) => h.color.value == targetColor.value)
// //         .toList();
// //
// //     if (filtered.isEmpty) {
// //       return '';
// //     }
// //
// //     final buffer = StringBuffer();
// //
// //     final byPage = <int, List<HighlightRegion>>{};
// //     for (final h in filtered) {
// //       byPage.putIfAbsent(h.page, () => []).add(h);
// //     }
// //
// //     for (final entry in byPage.entries) {
// //       final pageIndex = entry.key;
// //       final pageHighlights = entry.value;
// //
// //       final regions = await _getRegionsForPage(pageIndex);
// //
// //       buffer.writeln('===== Page ${pageIndex + 1} =====');
// //
// //       for (final h in pageHighlights) {
// //         final text = _extractTextForHighlight(
// //           highlightRectNormalized: h.rectNormalized,
// //           regions: regions,
// //         );
// //
// //         if (text.isNotEmpty) {
// //           buffer.writeln(text);
// //           buffer.writeln();
// //         }
// //       }
// //
// //       buffer.writeln();
// //     }
// //
// //     return buffer.toString().trim();
// //   }
// //
// //   // -----------------------------
// //   // OpenAI 프롬프트 생성 헬퍼
// //   // -----------------------------
// //
// //   String _buildReviewPrompt(String extractedText) {
// //     return '''
// // You are a helpful study assistant. Summarize and organize the following highlighted textbook content into Korean study notes.
// //
// // 요청:
// // 1. 핵심 개념을 항목별로 정리해 주세요.
// // 2. 시험에 나올만한 포인트는 별표(*)를 붙여 강조해 주세요.
// // 3. 필요한 경우 간단한 예시를 덧붙여 주세요.
// // 4. 전체 분량은 A4 한 페이지를 넘지 않게 요약해 주세요.
// //
// // [하이라이트 원문]
// // ```text
// // $extractedText
// // ```''';
// //   }
// //
// //   // -----------------------------
// //   // UI: 상단 툴바
// //   // -----------------------------
// //
// //   Widget _buildToolButton({
// //     required IconData icon,
// //     required DrawTool tool,
// //   }) {
// //     final isSelected = _tool == tool;
// //
// //     return IconButton(
// //       tooltip: tool == DrawTool.pen
// //           ? '펜'
// //           : tool == DrawTool.highlighter
// //               ? '형광펜'
// //               : '지우개',
// //       icon: Icon(
// //         icon,
// //         color: isSelected ? Colors.blueAccent : Colors.black54,
// //       ),
// //       onPressed: () {
// //         setState(() {
// //           _tool = tool;
// //         });
// //       },
// //     );
// //   }
// //
// //   Widget _buildColorDot(Color color) {
// //     final bool selected = _currentColor.value == color.value;
// //
// //     return GestureDetector(
// //       onTap: () {
// //         setState(() {
// //           _currentColor = color;
// //           if (_tool == DrawTool.eraser) {
// //             _tool = DrawTool.highlighter;
// //           }
// //         });
// //       },
// //       child: Container(
// //         margin: const EdgeInsets.symmetric(horizontal: 4),
// //         width: selected ? 26 : 22,
// //         height: selected ? 26 : 22,
// //         decoration: BoxDecoration(
// //           color: color,
// //           shape: BoxShape.circle,
// //           border: Border.all(
// //             color: selected ? Colors.black87 : Colors.black26,
// //             width: selected ? 2 : 1,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   PreferredSizeWidget _buildTopToolbar() {
// //     return PreferredSize(
// //       preferredSize: const Size.fromHeight(72),
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
// //         decoration: const BoxDecoration(
// //           color: Colors.white,
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black12,
// //               blurRadius: 4,
// //               offset: Offset(0, 1),
// //             ),
// //           ],
// //         ),
// //         child: Column(
// //           children: [
// //             Row(
// //               children: [
// //                 IconButton(
// //                   tooltip: '줌 (추후 구현 예정)',
// //                   icon: const Icon(Icons.search),
// //                   onPressed: () {
// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       const SnackBar(
// //                         content: Text('줌 기능은 나중에 구현할 예정입니다.'),
// //                         duration: Duration(seconds: 1),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //                 _buildToolButton(icon: Icons.edit, tool: DrawTool.pen),
// //                 _buildToolButton(
// //                     icon: Icons.border_color, tool: DrawTool.highlighter),
// //                 _buildToolButton(
// //                     icon: Icons.auto_fix_normal, tool: DrawTool.eraser),
// //                 const SizedBox(width: 8),
// //                 IconButton(
// //                   tooltip: '선택 도구 (추후 구현 예정)',
// //                   icon: const Icon(Icons.all_inclusive),
// //                   onPressed: () {
// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       const SnackBar(
// //                         content: Text('선택 도구는 나중에 구현할 예정입니다.'),
// //                         duration: Duration(seconds: 1),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //                 IconButton(
// //                   tooltip: '도형 (추후 구현 예정)',
// //                   icon: const Icon(Icons.crop_square),
// //                   onPressed: () {
// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       const SnackBar(
// //                         content: Text('도형 기능은 나중에 구현할 예정입니다.'),
// //                         duration: Duration(seconds: 1),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //                 const Spacer(),
// //                 IconButton(
// //                   tooltip: '되돌리기',
// //                   icon: const Icon(Icons.undo),
// //                   onPressed: _undo,
// //                 ),
// //                 IconButton(
// //                   tooltip: '다시 실행',
// //                   icon: const Icon(Icons.redo),
// //                   onPressed: _redo,
// //                 ),
// //                 IconButton(
// //                   tooltip: '전체 지우기',
// //                   icon: const Icon(Icons.delete_outline),
// //                   onPressed: _clearAll,
// //                 ),
// //               ],
// //             ),
// //             Row(
// //               children: [
// //                 _buildColorDot(Colors.yellowAccent),
// //                 _buildColorDot(Colors.lightBlueAccent),
// //                 _buildColorDot(Colors.pinkAccent),
// //                 _buildColorDot(Colors.greenAccent),
// //                 _buildColorDot(Colors.orangeAccent),
// //                 const SizedBox(width: 12),
// //                 const Text(
// //                   '두께',
// //                   style: TextStyle(fontSize: 12),
// //                 ),
// //                 Expanded(
// //                   child: Slider(
// //                     value: _currentWidth,
// //                     min: 4,
// //                     max: 28,
// //                     divisions: 12,
// //                     onChanged: (value) {
// //                       setState(() {
// //                         _currentWidth = value;
// //                       });
// //                     },
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // -----------------------------
// //   // 오른쪽 AI 패널 UI
// //   // -----------------------------
// //
// //   Widget _buildRightAiPanel() {
// //     final currentPageHighlights =
// //         _highlights.where((h) => h.page == _currentPage).toList();
// //
// //     return Container(
// //       width: 320,
// //       decoration: const BoxDecoration(
// //         color: Color(0xFFF7F8FA),
// //         border: Border(
// //           left: BorderSide(color: Color(0xFFDDDDDD)),
// //         ),
// //       ),
// //       child: Column(
// //         children: [
// //           // 헤더
// //           Container(
// //             padding:
// //                 const EdgeInsets.only(top: 12, bottom: 8, left: 16, right: 16),
// //             decoration: const BoxDecoration(
// //               color: Colors.white,
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black12,
// //                   blurRadius: 3,
// //                   offset: Offset(0, 1),
// //                 ),
// //               ],
// //             ),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 const Text(
// //                   'AI 학습 패널',
// //                   style: TextStyle(
// //                     fontWeight: FontWeight.bold,
// //                     fontSize: 16,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 6),
// //                 Row(
// //                   children: [
// //                     Container(
// //                       width: 10,
// //                       height: 10,
// //                       margin: const EdgeInsets.only(right: 6),
// //                       decoration: BoxDecoration(
// //                         color: _currentColor,
// //                         shape: BoxShape.circle,
// //                         border: Border.all(color: Colors.black26),
// //                       ),
// //                     ),
// //                     Expanded(
// //                       child: Text(
// //                         '현재 태그: $_currentTagLabel',
// //                         style: const TextStyle(
// //                           fontSize: 12,
// //                           color: Colors.black87,
// //                         ),
// //                         overflow: TextOverflow.ellipsis,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 4),
// //                 Text(
// //                   '현재 페이지: ${_currentPage + 1} / $_totalPages, '
// //                   '하이라이트 ${currentPageHighlights.length}개',
// //                   style: const TextStyle(
// //                     fontSize: 11,
// //                     color: Colors.black54,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //
// //           // 내용 영역
// //           Expanded(
// //             child: Padding(
// //               padding:
// //                   const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
// //               child: ListView(
// //                 children: [
// //                   const SizedBox(height: 8),
// //                   const Text(
// //                     '하이라이트 좌표 (디버그 용)',
// //                     style: TextStyle(
// //                       fontWeight: FontWeight.w600,
// //                       fontSize: 13,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 6),
// //                   if (currentPageHighlights.isEmpty)
// //                     Container(
// //                       padding: const EdgeInsets.all(10),
// //                       decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         borderRadius: BorderRadius.circular(8),
// //                         border: Border.all(color: Color(0xFFDDDDDD)),
// //                       ),
// //                       child: const Text(
// //                         '이 페이지에서 형광펜으로 문장을 긋고 나면, '
// //                         '정규화된 좌표 정보가 여기에 표시됩니다.',
// //                         style: TextStyle(fontSize: 12, height: 1.4),
// //                       ),
// //                     )
// //                   else
// //                     ...currentPageHighlights.map((h) {
// //                       final r = h.rectNormalized;
// //                       return Container(
// //                         margin: const EdgeInsets.only(bottom: 6),
// //                         padding: const EdgeInsets.all(8),
// //                         decoration: BoxDecoration(
// //                           color: Colors.white,
// //                           borderRadius: BorderRadius.circular(6),
// //                           border:
// //                               Border.all(color: const Color(0xFFE0E0E0)),
// //                         ),
// //                         child: Text(
// //                           'page=${h.page}, '
// //                           'left=${r.left.toStringAsFixed(3)}, '
// //                           'top=${r.top.toStringAsFixed(3)}, '
// //                           'right=${r.right.toStringAsFixed(3)}, '
// //                           'bottom=${r.bottom.toStringAsFixed(3)}',
// //                           style: const TextStyle(
// //                             fontSize: 11,
// //                             height: 1.3,
// //                           ),
// //                         ),
// //                       );
// //                     }),
// //                   const SizedBox(height: 16),
// //                   const Text(
// //                     'AI 작업 히스토리 (향후)',
// //                     style: TextStyle(
// //                       fontWeight: FontWeight.w600,
// //                       fontSize: 13,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 6),
// //                   _buildHistoryPlaceholder(
// //                     title: '복습 요약',
// //                     description: '노랑 태그로 긋는 구간이 여기에 쌓일 예정입니다.',
// //                   ),
// //                   const SizedBox(height: 8),
// //                   _buildHistoryPlaceholder(
// //                     title: '심화 설명',
// //                     description: '하늘 태그로 긋는 구간의 심화 설명이 저장됩니다.',
// //                   ),
// //                   const SizedBox(height: 8),
// //                   _buildHistoryPlaceholder(
// //                     title: '예제/문제',
// //                     description: '예제 태그를 기반으로 자동 문제가 생성됩니다.',
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //
// //           // 하단 버튼 영역
// //           Container(
// //             padding:
// //                 const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
// //             decoration: const BoxDecoration(
// //               color: Colors.white,
// //               border: Border(
// //                 top: BorderSide(color: Color(0xFFDDDDDD)),
// //               ),
// //             ),
// //             child: Column(
// //               children: [
// //                 // 1) JSON 로그
// //                 SizedBox(
// //                   width: double.infinity,
// //                   child: ElevatedButton.icon(
// //                     icon: const Icon(Icons.code, size: 18),
// //                     label: const Text(
// //                       '하이라이트 JSON 로그',
// //                       style: TextStyle(fontSize: 13),
// //                     ),
// //                     onPressed: () {
// //                       for (final h in _highlights) {
// //                         debugPrint(h.toString());
// //                       }
// //                       ScaffoldMessenger.of(context).showSnackBar(
// //                         const SnackBar(
// //                           content:
// //                               Text('디버그 콘솔에서 하이라이트 정보를 확인할 수 있습니다.'),
// //                           duration: Duration(seconds: 1),
// //                         ),
// //                       );
// //                     },
// //                   ),
// //                 ),
// //                 const SizedBox(height: 6),
// //
// //                 // 2) 노랑 하이라이트 → OpenAI 프롬프트 복사
// //                 SizedBox(
// //                   width: double.infinity,
// //                   child: ElevatedButton.icon(
// //                     icon: const Icon(Icons.content_copy, size: 18),
// //                     label: const Text(
// //                       '노랑 프롬프트 클립보드 복사',
// //                       style: TextStyle(fontSize: 13),
// //                     ),
// //                     onPressed: () async {
// //                       try {
// //                         final extracted =
// //                             await _collectHighlightTextByColor(
// //                           Colors.yellowAccent,
// //                         );
// //
// //                         if (!mounted) return;
// //
// //                         if (extracted.isEmpty) {
// //                           ScaffoldMessenger.of(context).showSnackBar(
// //                             const SnackBar(
// //                               content:
// //                                   Text('노랑 하이라이트에 매핑된 텍스트가 없습니다.'),
// //                               duration: Duration(seconds: 1),
// //                             ),
// //                           );
// //                           return;
// //                         }
// //
// //                         final prompt = _buildReviewPrompt(extracted);
// //                         await Clipboard.setData(
// //                           ClipboardData(text: prompt),
// //                         );
// //
// //                         ScaffoldMessenger.of(context).showSnackBar(
// //                           const SnackBar(
// //                             content:
// //                                 Text('노랑 하이라이트 프롬프트를 클립보드에 복사했습니다.'),
// //                             duration: Duration(seconds: 2),
// //                           ),
// //                         );
// //                       } catch (e) {
// //                         if (!mounted) return;
// //                         ScaffoldMessenger.of(context).showSnackBar(
// //                           SnackBar(
// //                             content:
// //                                 Text('프롬프트 생성 중 오류가 발생했습니다: $e'),
// //                             duration: const Duration(seconds: 2),
// //                           ),
// //                         );
// //                       }
// //                     },
// //                   ),
// //                 ),
// //                 const SizedBox(height: 6),
// //
// //                 // 3) 노랑 하이라이트 텍스트 보기 (그냥 원문 확인용)
// //                 SizedBox(
// //                   width: double.infinity,
// //                   child: ElevatedButton.icon(
// //                     icon: const Icon(Icons.highlight, size: 18),
// //                     label: const Text(
// //                       '노랑 하이라이트 텍스트 보기',
// //                       style: TextStyle(fontSize: 13),
// //                     ),
// //                     onPressed: () async {
// //                       try {
// //                         final result = await _collectHighlightTextByColor(
// //                           Colors.yellowAccent,
// //                         );
// //
// //                         if (!mounted) return;
// //
// //                         if (result.isEmpty) {
// //                           ScaffoldMessenger.of(context).showSnackBar(
// //                             const SnackBar(
// //                               content: Text('노랑 하이라이트에 매핑된 텍스트가 없습니다.'),
// //                               duration: Duration(seconds: 1),
// //                             ),
// //                           );
// //                           return;
// //                         }
// //
// //                         await showDialog(
// //                           context: context,
// //                           builder: (context) {
// //                             return AlertDialog(
// //                               title: const Text('노랑 하이라이트 텍스트'),
// //                               content: SizedBox(
// //                                 width: double.maxFinite,
// //                                 child: SingleChildScrollView(
// //                                   child: Text(
// //                                     result,
// //                                     style: const TextStyle(
// //                                       fontSize: 13,
// //                                       height: 1.4,
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ),
// //                               actions: [
// //                                 TextButton(
// //                                   onPressed: () =>
// //                                       Navigator.of(context).pop(),
// //                                   child: const Text('닫기'),
// //                                 ),
// //                               ],
// //                             );
// //                           },
// //                         );
// //                       } catch (e) {
// //                         if (!mounted) return;
// //                         ScaffoldMessenger.of(context).showSnackBar(
// //                           SnackBar(
// //                             content: Text('텍스트 추출 중 오류가 발생했습니다: $e'),
// //                             duration: const Duration(seconds: 2),
// //                           ),
// //                         );
// //                       }
// //                     },
// //                   ),
// //                 ),
// //                 const SizedBox(height: 6),
// //
// //                 // 4) 전체 복습 콘텐츠 보기 (향후)
// //                 SizedBox(
// //                   width: double.infinity,
// //                   child: OutlinedButton(
// //                     child: const Text(
// //                       '전체 복습 콘텐츠 보기 (향후)',
// //                       style: TextStyle(fontSize: 12),
// //                     ),
// //                     onPressed: () {
// //                       ScaffoldMessenger.of(context).showSnackBar(
// //                         const SnackBar(
// //                           content: Text('복습 콘텐츠 화면은 추후 구현 예정입니다.'),
// //                           duration: Duration(seconds: 1),
// //                         ),
// //                       );
// //                     },
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   static Widget _buildHistoryPlaceholder({
// //     required String title,
// //     required String description,
// //   }) {
// //     return Container(
// //       padding: const EdgeInsets.all(10),
// //       decoration: BoxDecoration(
// //         color: const Color(0xFFFFFFFF),
// //         borderRadius: BorderRadius.circular(8),
// //         border: Border.all(color: const Color(0xFFE0E0E0)),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             title,
// //             style: const TextStyle(
// //               fontWeight: FontWeight.w600,
// //               fontSize: 12,
// //             ),
// //           ),
// //           const SizedBox(height: 4),
// //           Text(
// //             description,
// //             style: const TextStyle(
// //               fontSize: 11,
// //               color: Colors.black54,
// //               height: 1.3,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   // -----------------------------
// //   // 화면 전체 빌드
// //   // -----------------------------
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Study Highlight PDF'),
// //         centerTitle: true,
// //         bottom: _buildTopToolbar(),
// //       ),
// //       body: Row(
// //         children: [
// //           // 왼쪽: PDF + 드로잉
// //           Expanded(
// //             child: Stack(
// //               children: [
// //                 Positioned.fill(
// //                   child: PDFView(
// //                     filePath: widget.path,
// //                     enableSwipe: true,
// //                     swipeHorizontal: true,
// //                     autoSpacing: true,
// //                     pageFling: true,
// //                     onRender: (pages) {
// //                       setState(() {
// //                         _totalPages = pages ?? 0;
// //                       });
// //                     },
// //                     onPageChanged: (page, total) {
// //                       setState(() {
// //                         _currentPage = page ?? 0;
// //                       });
// //                     },
// //                   ),
// //                 ),
// //                 Positioned.fill(
// //                   child: RepaintBoundary(
// //                     key: _canvasKey,
// //                     child: GestureDetector(
// //                       behavior: HitTestBehavior.translucent,
// //                       onPanStart: _onPanStart,
// //                       onPanUpdate: _onPanUpdate,
// //                       onPanEnd: _onPanEnd,
// //                       child: CustomPaint(
// //                         painter: DrawingPainter(_strokes),
// //                         size: Size.infinite,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //
// //           // 오른쪽: AI 패널
// //           _buildRightAiPanel(),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:flutter_pdf_text/flutter_pdf_text.dart'; // ✅ flutter_pdf_text 사용
//
// void main() {
//   runApp(const StudyHighlightApp());
// }
//
// class StudyHighlightApp extends StatelessWidget {
//   const StudyHighlightApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Study Highlight',
//       debugShowCheckedModeBanner: false,
//       home: const StudyHomePage(),
//     );
//   }
// }
//
// /// 홈 화면: PDF 선택
// class StudyHomePage extends StatelessWidget {
//   const StudyHomePage({super.key});
//
//   Future<void> _openPdf(BuildContext context) async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );
//
//     if (result == null || result.files.single.path == null) return;
//
//     final path = result.files.single.path!;
//
//     Navigator.of(context).push(
//       MaterialPageRoute(builder: (_) => PDFDrawScreen(path: path)),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(
//         title: const Text('Study Highlight 노트'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.note_alt_outlined, size: 80),
//             const SizedBox(height: 16),
//             const Text(
//               'PDF를 선택해서 공부를 시작하세요.',
//               style: TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () => _openPdf(context),
//               child: const Text('PDF 열기'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // -----------------------------
// // PDF 텍스트 추출용 리포지토리
// // -----------------------------
//
// class PdfTextRepository {
//   PDFDoc? _doc;
//   final Map<int, String> _pageTextCache = {};
//
//   Future<void> load(String path) async {
//     _doc = await PDFDoc.fromPath(path);
//   }
//
//   Future<String> getPageText(int pageIndex) async {
//     final doc = _doc;
//     if (doc == null) {
//       throw Exception('PDF 텍스트 문서를 아직 로드하지 않았습니다.');
//     }
//
//     if (_pageTextCache.containsKey(pageIndex)) {
//       return _pageTextCache[pageIndex]!;
//     }
//
//     // flutter_pdf_text 는 1-based 페이지 인덱스 사용
//     final page = await doc.pageAt(pageIndex + 1);
//     final text = await page.text;
//     _pageTextCache[pageIndex] = text;
//     return text;
//   }
// }
//
// // -----------------------------
// // 드로잉 관련 모델
// // -----------------------------
//
// enum DrawTool {
//   pen,
//   highlighter,
//   eraser,
// }
//
// class Stroke {
//   Stroke({
//     required this.points,
//     required this.color,
//     required this.width,
//     required this.tool,
//   });
//
//   final List<Offset> points;
//   final Color color;
//   final double width;
//   final DrawTool tool;
// }
//
// /// 형광펜 Stroke를 기반으로 만든 "하이라이트 영역"
// class HighlightRegion {
//   HighlightRegion({
//     required this.page,
//     required this.rectNormalized,
//     required this.color,
//   });
//
//   final int page; // 0 기반 현재 페이지
//   final Rect rectNormalized; // 0~1 로 정규화된 좌표
//   final Color color;
//
//   Map<String, dynamic> toJson() {
//     return {
//       'page': page,
//       'rect': {
//         'left': rectNormalized.left,
//         'top': rectNormalized.top,
//         'right': rectNormalized.right,
//         'bottom': rectNormalized.bottom,
//       },
//       'color': color.value.toRadixString(16),
//     };
//   }
//
//   @override
//   String toString() => toJson().toString();
// }
//
// /// 한 줄(or 블록)에 해당하는 텍스트와 그 위치 정보
// class TextRegion {
//   final Rect rectNormalized; // 0~1 기준
//   final String text;
//
//   TextRegion({
//     required this.rectNormalized,
//     required this.text,
//   });
// }
//
// /// 페이지 텍스트를 TextRegion 리스트로 바꿔주는 헬퍼
// /// (현재는 "줄 개수 기준으로 동일 높이로 나누는 1차 버전")
// class PageTextLayoutService {
//   List<TextRegion> buildRegions({
//     required String pageText,
//     required Size pageSize,
//   }) {
//     final lines = pageText.split('\n');
//     final regions = <TextRegion>[];
//
//     if (lines.isEmpty || pageSize.height <= 0) {
//       return regions;
//     }
//
//     final lineCount = lines.length;
//     final lineHeight = pageSize.height / lineCount;
//
//     for (var i = 0; i < lineCount; i++) {
//       final text = lines[i].trim();
//       if (text.isEmpty) continue;
//
//       final top = i * lineHeight;
//       final rect = Rect.fromLTWH(0, top, pageSize.width, lineHeight);
//
//       final rectNormalized = Rect.fromLTWH(
//         rect.left / pageSize.width,
//         rect.top / pageSize.height,
//         rect.width / pageSize.width,
//         rect.height / pageSize.height,
//       );
//
//       regions.add(
//         TextRegion(
//           rectNormalized: rectNormalized,
//           text: text,
//         ),
//       );
//     }
//
//     return regions;
//   }
// }
//
// // -----------------------------
// // Stroke 리스트를 그리는 Painter
// // -----------------------------
//
// class DrawingPainter extends CustomPainter {
//   final List<Stroke> strokes;
//
//   DrawingPainter(this.strokes);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     for (final stroke in strokes) {
//       if (stroke.points.length < 2) continue;
//
//       final paint = Paint()
//         ..color = (stroke.tool == DrawTool.highlighter)
//             ? stroke.color.withOpacity(0.7)
//             : stroke.color
//         ..strokeWidth = stroke.width
//         ..strokeCap = StrokeCap.round
//         ..strokeJoin = StrokeJoin.round
//         ..style = PaintingStyle.stroke;
//
//       for (int i = 0; i < stroke.points.length - 1; i++) {
//         final p1 = stroke.points[i];
//         final p2 = stroke.points[i + 1];
//         canvas.drawLine(p1, p2, paint);
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant DrawingPainter oldDelegate) {
//     return true;
//   }
// }
//
// // -----------------------------
// // PDF + 드로잉 + 상단 툴바 + 오른쪽 AI 패널 화면
// // -----------------------------
//
// class PDFDrawScreen extends StatefulWidget {
//   final String path;
//   const PDFDrawScreen({super.key, required this.path});
//
//   @override
//   State<PDFDrawScreen> createState() => _PDFDrawScreenState();
// }
//
// class _PDFDrawScreenState extends State<PDFDrawScreen> {
//   final List<Stroke> _strokes = [];
//   final List<Stroke> _redoStack = [];
//
//   Stroke? _currentStroke;
//
//   // 현재 도구/색상/두께
//   DrawTool _tool = DrawTool.highlighter;
//   Color _currentColor = Colors.yellowAccent;
//   double _currentWidth = 16.0;
//
//   // PDF 페이지 상태
//   int _currentPage = 0;
//   int _totalPages = 0;
//
//   // 형광펜 하이라이트 영역 리스트
//   final List<HighlightRegion> _highlights = [];
//
//   // 캔버스 영역 기준 좌표 변환용 키
//   final GlobalKey _canvasKey = GlobalKey();
//
//   // PDF 텍스트 및 레이아웃 캐시
//   final PdfTextRepository _pdfTextRepository = PdfTextRepository();
//   final PageTextLayoutService _pageTextLayoutService = PageTextLayoutService();
//   final Map<int, List<TextRegion>> _pageRegionsCache = {}; // pageIndex → regions
//
//   @override
//   void initState() {
//     super.initState();
//     _initPdfText();
//   }
//
//   Future<void> _initPdfText() async {
//     try {
//       await _pdfTextRepository.load(widget.path);
//       debugPrint('PDF 텍스트 로드 완료');
//     } catch (e) {
//       debugPrint('PDF 텍스트 로드 실패: $e');
//     }
//   }
//
//   // -----------------------------
//   // 헬퍼: 색상 → 태그 레이블
//   // -----------------------------
//   String get _currentTagLabel {
//     if (_currentColor.value == Colors.yellowAccent.value) {
//       return '복습(Review)';
//     } else if (_currentColor.value == Colors.lightBlueAccent.value) {
//       return '심화(Deep)';
//     } else if (_currentColor.value == Colors.pinkAccent.value) {
//       return '예제(Example)';
//     } else if (_currentColor.value == Colors.greenAccent.value) {
//       return '정리(Summary)';
//     } else if (_currentColor.value == Colors.orangeAccent.value) {
//       return '기타(Custom)';
//     } else {
//       return '태그 미지정';
//     }
//   }
//
//   // -----------------------------
//   // 드로잉 로직
//   // -----------------------------
//
//   Offset _toLocal(Offset globalPosition) {
//     final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
//     if (box == null) return globalPosition;
//     return box.globalToLocal(globalPosition);
//   }
//
//   void _onPanStart(DragStartDetails details) {
//     final pos = _toLocal(details.globalPosition);
//
//     // 지우개 모드: Stroke 제거
//     if (_tool == DrawTool.eraser) {
//       _eraseAt(pos);
//       return;
//     }
//
//     final width = (_tool == DrawTool.highlighter)
//         ? _currentWidth
//         : (_currentWidth / 1.8).clamp(2.0, 12.0);
//
//     _currentStroke = Stroke(
//       points: [pos],
//       color: _currentColor,
//       width: width,
//       tool: _tool,
//     );
//
//     setState(() {
//       _strokes.add(_currentStroke!);
//       _redoStack.clear();
//     });
//   }
//
//   void _onPanUpdate(DragUpdateDetails details) {
//     final pos = _toLocal(details.globalPosition);
//
//     if (_tool == DrawTool.eraser) {
//       _eraseAt(pos);
//       return;
//     }
//
//     if (_currentStroke == null) return;
//
//     setState(() {
//       _currentStroke!.points.add(pos);
//     });
//   }
//
//   void _onPanEnd(DragEndDetails details) {
//     if (_currentStroke != null && _currentStroke!.tool == DrawTool.highlighter) {
//       _saveHighlightFromStroke(_currentStroke!);
//     }
//     _currentStroke = null;
//   }
//
//   // Stroke → HighlightRegion 변환
//   void _saveHighlightFromStroke(Stroke stroke) {
//     if (stroke.points.length < 2) return;
//
//     final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
//     if (box == null) return;
//
//     final size = box.size;
//
//     double minX = stroke.points.first.dx;
//     double maxX = stroke.points.first.dx;
//     double minY = stroke.points.first.dy;
//     double maxY = stroke.points.first.dy;
//
//     for (final p in stroke.points) {
//       if (p.dx < minX) minX = p.dx;
//       if (p.dx > maxX) maxX = p.dx;
//       if (p.dy < minY) minY = p.dy;
//       if (p.dy > maxY) maxY = p.dy;
//     }
//
//     const padding = 4.0;
//     minX = (minX - padding).clamp(0.0, size.width);
//     maxX = (maxX + padding).clamp(0.0, size.width);
//     minY = (minY - padding).clamp(0.0, size.height);
//     maxY = (maxY + padding).clamp(0.0, size.height);
//
//     final rect = Rect.fromLTRB(minX, minY, maxX, maxY);
//
//     final normalized = Rect.fromLTRB(
//       rect.left / size.width,
//       rect.top / size.height,
//       rect.right / size.width,
//       rect.bottom / size.height,
//     );
//
//     final region = HighlightRegion(
//       page: _currentPage,
//       rectNormalized: normalized,
//       color: stroke.color,
//     );
//
//     setState(() {
//       _highlights.add(region);
//     });
//
//     debugPrint('New highlight: $region');
//   }
//
//   // 지우개: 현재 위치 근처에 있는 Stroke를 제거
//   void _eraseAt(Offset pos) {
//     const double threshold = 20.0;
//
//     setState(() {
//       _strokes.removeWhere((stroke) {
//         return stroke.points.any(
//           (p) => (p - pos).distance <= threshold,
//         );
//       });
//
//       _highlights.removeWhere((region) {
//         final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
//         if (box == null) return false;
//         final size = box.size;
//
//         final rect = Rect.fromLTRB(
//           region.rectNormalized.left * size.width,
//           region.rectNormalized.top * size.height,
//           region.rectNormalized.right * size.width,
//           region.rectNormalized.bottom * size.height,
//         );
//         final center = rect.center;
//         return (center - pos).distance <= threshold;
//       });
//     });
//   }
//
//   // Undo / Redo / Clear
//   void _undo() {
//     if (_strokes.isEmpty) return;
//     setState(() {
//       final last = _strokes.removeLast();
//       _redoStack.add(last);
//       if (_highlights.isNotEmpty) {
//         _highlights.removeLast();
//       }
//     });
//   }
//
//   void _redo() {
//     if (_redoStack.isEmpty) return;
//     setState(() {
//       final stroke = _redoStack.removeLast();
//       _strokes.add(stroke);
//     });
//   }
//
//   void _clearAll() {
//     setState(() {
//       _strokes.clear();
//       _redoStack.clear();
//       _highlights.clear();
//     });
//   }
//
//   // -----------------------------
//   // TextRegion 관련 헬퍼
//   // -----------------------------
//
//   Future<List<TextRegion>> _getRegionsForPage(int pageIndex) async {
//     if (_pageRegionsCache.containsKey(pageIndex)) {
//       return _pageRegionsCache[pageIndex]!;
//     }
//
//     final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
//     if (box == null) {
//       throw Exception('캔버스 RenderBox를 찾을 수 없습니다.');
//     }
//     final pageSize = box.size;
//
//     final pageText = await _pdfTextRepository.getPageText(pageIndex);
//
//     final regions = _pageTextLayoutService.buildRegions(
//       pageText: pageText,
//       pageSize: pageSize,
//     );
//
//     _pageRegionsCache[pageIndex] = regions;
//     return regions;
//   }
//
//   String _extractTextForHighlight({
//     required Rect highlightRectNormalized,
//     required List<TextRegion> regions,
//   }) {
//     final buffer = StringBuffer();
//
//     for (final region in regions) {
//       if (highlightRectNormalized.overlaps(region.rectNormalized)) {
//         buffer.writeln(region.text.trim());
//       }
//     }
//
//     return buffer.toString().trim();
//   }
//
//   /// 특정 색상의 하이라이트 텍스트를 전 페이지에서 모아서 하나의 문자열로 합치기
//   Future<String> _collectHighlightTextByColor(Color targetColor) async {
//     if (_highlights.isEmpty) {
//       return '';
//     }
//
//     final filtered = _highlights
//         .where((h) => h.color.value == targetColor.value)
//         .toList();
//
//     if (filtered.isEmpty) {
//       return '';
//     }
//
//     final buffer = StringBuffer();
//
//     final byPage = <int, List<HighlightRegion>>{};
//     for (final h in filtered) {
//       byPage.putIfAbsent(h.page, () => []).add(h);
//     }
//
//     for (final entry in byPage.entries) {
//       final pageIndex = entry.key;
//       final pageHighlights = entry.value;
//
//       final regions = await _getRegionsForPage(pageIndex);
//
//       buffer.writeln('===== Page ${pageIndex + 1} =====');
//
//       for (final h in pageHighlights) {
//         final text = _extractTextForHighlight(
//           highlightRectNormalized: h.rectNormalized,
//           regions: regions,
//         );
//
//         if (text.isNotEmpty) {
//           buffer.writeln(text);
//           buffer.writeln();
//         }
//       }
//
//       buffer.writeln();
//     }
//
//     return buffer.toString().trim();
//   }
//
//   // -----------------------------
//   // OpenAI 프롬프트 생성 헬퍼
//   // -----------------------------
//
//   String _buildOpenAIPrompt(String highlightText) {
//     final buffer = StringBuffer();
//
//     buffer.writeln(
//         'You are a helpful study assistant. Summarize and organize the following highlighted textbook content into Korean study notes.');
//     buffer.writeln();
//     buffer.writeln('요청:');
//     buffer.writeln('1. 핵심 개념을 항목별로 정리해 주세요.');
//     buffer.writeln('2. 시험에 나올만한 포인트는 별표(*)를 붙여 강조해 주세요.');
//     buffer.writeln('3. 필요한 경우 간단한 예시를 덧붙여 주세요.');
//     buffer.writeln('4. 전체 분량은 A4 한 페이지를 넘지 않게 요약해 주세요.');
//     buffer.writeln();
//     buffer.writeln('[하이라이트 원문]');
//     buffer.writeln('```text');
//     buffer.writeln(highlightText);
//     buffer.writeln('```');
//
//     return buffer.toString();
//   }
//
//   // -----------------------------
//   // UI: 상단 툴바
//   // -----------------------------
//
//   Widget _buildToolButton({
//     required IconData icon,
//     required DrawTool tool,
//   }) {
//     final isSelected = _tool == tool;
//
//     return IconButton(
//       tooltip: tool == DrawTool.pen
//           ? '펜'
//           : tool == DrawTool.highlighter
//               ? '형광펜'
//               : '지우개',
//       icon: Icon(
//         icon,
//         color: isSelected ? Colors.blueAccent : Colors.black54,
//       ),
//       onPressed: () {
//         setState(() {
//           _tool = tool;
//         });
//       },
//     );
//   }
//
//   Widget _buildColorDot(Color color) {
//     final bool selected = _currentColor.value == color.value;
//
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _currentColor = color;
//           if (_tool == DrawTool.eraser) {
//             _tool = DrawTool.highlighter;
//           }
//         });
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 4),
//         width: selected ? 26 : 22,
//         height: selected ? 26 : 22,
//         decoration: BoxDecoration(
//           color: color,
//           shape: BoxShape.circle,
//           border: Border.all(
//             color: selected ? Colors.black87 : Colors.black26,
//             width: selected ? 2 : 1,
//           ),
//         ),
//       ),
//     );
//   }
//
//   PreferredSizeWidget _buildTopToolbar() {
//     return PreferredSize(
//       preferredSize: const Size.fromHeight(72),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 4,
//               offset: Offset(0, 1),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 IconButton(
//                   tooltip: '줌 (추후 구현 예정)',
//                   icon: const Icon(Icons.search),
//                   onPressed: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('줌 기능은 나중에 구현할 예정입니다.'),
//                         duration: Duration(seconds: 1),
//                       ),
//                     );
//                   },
//                 ),
//                 _buildToolButton(icon: Icons.edit, tool: DrawTool.pen),
//                 _buildToolButton(
//                     icon: Icons.border_color, tool: DrawTool.highlighter),
//                 _buildToolButton(
//                     icon: Icons.auto_fix_normal, tool: DrawTool.eraser),
//                 const SizedBox(width: 8),
//                 IconButton(
//                   tooltip: '선택 도구 (추후 구현 예정)',
//                   icon: const Icon(Icons.all_inclusive),
//                   onPressed: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('선택 도구는 나중에 구현할 예정입니다.'),
//                         duration: Duration(seconds: 1),
//                       ),
//                     );
//                   },
//                 ),
//                 IconButton(
//                   tooltip: '도형 (추후 구현 예정)',
//                   icon: const Icon(Icons.crop_square),
//                   onPressed: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('도형 기능은 나중에 구현할 예정입니다.'),
//                         duration: Duration(seconds: 1),
//                       ),
//                     );
//                   },
//                 ),
//                 const Spacer(),
//                 IconButton(
//                   tooltip: '되돌리기',
//                   icon: const Icon(Icons.undo),
//                   onPressed: _undo,
//                 ),
//                 IconButton(
//                   tooltip: '다시 실행',
//                   icon: const Icon(Icons.redo),
//                   onPressed: _redo,
//                 ),
//                 IconButton(
//                   tooltip: '전체 지우기',
//                   icon: const Icon(Icons.delete_outline),
//                   onPressed: _clearAll,
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 _buildColorDot(Colors.yellowAccent),
//                 _buildColorDot(Colors.lightBlueAccent),
//                 _buildColorDot(Colors.pinkAccent),
//                 _buildColorDot(Colors.greenAccent),
//                 _buildColorDot(Colors.orangeAccent),
//                 const SizedBox(width: 12),
//                 const Text(
//                   '두께',
//                   style: TextStyle(fontSize: 12),
//                 ),
//                 Expanded(
//                   child: Slider(
//                     value: _currentWidth,
//                     min: 4,
//                     max: 28,
//                     divisions: 12,
//                     onChanged: (value) {
//                       setState(() {
//                         _currentWidth = value;
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // -----------------------------
//   // 오른쪽 AI 패널 UI
//   // -----------------------------
//
//   Widget _buildRightAiPanel() {
//     final currentPageHighlights =
//         _highlights.where((h) => h.page == _currentPage).toList();
//
//     return Container(
//       width: 320,
//       decoration: const BoxDecoration(
//         color: Color(0xFFF7F8FA),
//         border: Border(
//           left: BorderSide(color: Color(0xFFDDDDDD)),
//         ),
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding:
//                 const EdgeInsets.only(top: 12, bottom: 8, left: 16, right: 16),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 3,
//                   offset: Offset(0, 1),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'AI 학습 패널',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Row(
//                   children: [
//                     Container(
//                       width: 10,
//                       height: 10,
//                       margin: const EdgeInsets.only(right: 6),
//                       decoration: BoxDecoration(
//                         color: _currentColor,
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.black26),
//                       ),
//                     ),
//                     Expanded(
//                       child: Text(
//                         '현재 태그: $_currentTagLabel',
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Colors.black87,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '현재 페이지: ${_currentPage + 1} / $_totalPages, '
//                   '하이라이트 ${currentPageHighlights.length}개',
//                   style: const TextStyle(
//                     fontSize: 11,
//                     color: Colors.black54,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//               child: ListView(
//                 children: [
//                   const SizedBox(height: 8),
//                   const Text(
//                     '하이라이트 좌표 (디버그 용)',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 13,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   if (currentPageHighlights.isEmpty)
//                     Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: Color(0xFFDDDDDD)),
//                       ),
//                       child: const Text(
//                         '이 페이지에서 형광펜으로 문장을 긋고 나면, '
//                         '정규화된 좌표 정보가 여기에 표시됩니다.',
//                         style: TextStyle(fontSize: 12, height: 1.4),
//                       ),
//                     )
//                   else
//                     ...currentPageHighlights.map((h) {
//                       final r = h.rectNormalized;
//                       return Container(
//                         margin: const EdgeInsets.only(bottom: 6),
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(6),
//                           border: Border.all(color: const Color(0xFFE0E0E0)),
//                         ),
//                         child: Text(
//                           'page=${h.page}, '
//                           'left=${r.left.toStringAsFixed(3)}, '
//                           'top=${r.top.toStringAsFixed(3)}, '
//                           'right=${r.right.toStringAsFixed(3)}, '
//                           'bottom=${r.bottom.toStringAsFixed(3)}',
//                           style: const TextStyle(
//                             fontSize: 11,
//                             height: 1.3,
//                           ),
//                         ),
//                       );
//                     }),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'AI 작업 히스토리 (향후)',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 13,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   _buildHistoryPlaceholder(
//                     title: '복습 요약',
//                     description: '노랑 태그로 긋는 구간이 여기에 쌓일 예정입니다.',
//                   ),
//                   const SizedBox(height: 8),
//                   _buildHistoryPlaceholder(
//                     title: '심화 설명',
//                     description: '하늘 태그로 긋는 구간의 심화 설명이 저장됩니다.',
//                   ),
//                   const SizedBox(height: 8),
//                   _buildHistoryPlaceholder(
//                     title: '예제/문제',
//                     description: '예제 태그를 기반으로 자동 문제가 생성됩니다.',
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               border: Border(
//                 top: BorderSide(color: Color(0xFFDDDDDD)),
//               ),
//             ),
//             child: Column(
//               children: [
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton.icon(
//                     icon: const Icon(Icons.code, size: 18),
//                     label: const Text(
//                       '하이라이트 JSON 로그',
//                       style: TextStyle(fontSize: 13),
//                     ),
//                     onPressed: () {
//                       for (final h in _highlights) {
//                         debugPrint(h.toString());
//                       }
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content:
//                               Text('디버그 콘솔에서 하이라이트 정보를 확인할 수 있습니다.'),
//                           duration: Duration(seconds: 1),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton.icon(
//                     icon: const Icon(Icons.highlight, size: 18),
//                     label: const Text(
//                       '노랑 하이라이트 → OpenAI 프롬프트',
//                       style: TextStyle(fontSize: 13),
//                     ),
//                     onPressed: () async {
//                       try {
//                         final highlightText =
//                             await _collectHighlightTextByColor(
//                           Colors.yellowAccent,
//                         );
//
//                         if (!mounted) return;
//
//                         if (highlightText.isEmpty) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content:
//                                   Text('노랑 하이라이트에 매핑된 텍스트가 없습니다.'),
//                               duration: Duration(seconds: 1),
//                             ),
//                           );
//                           return;
//                         }
//
//                         final prompt =
//                             _buildOpenAIPrompt(highlightText);
//
//                         await showDialog(
//                           context: context,
//                           builder: (context) {
//                             return AlertDialog(
//                               title:
//                                   const Text('노랑 하이라이트 텍스트 / OpenAI 프롬프트'),
//                               content: SizedBox(
//                                 width: double.maxFinite,
//                                 child: SingleChildScrollView(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       const Text(
//                                         '[하이라이트 원문]',
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 14,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 8),
//                                       SelectableText(
//                                         highlightText,
//                                         style: const TextStyle(
//                                           fontSize: 13,
//                                           height: 1.4,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 16),
//                                       const Text(
//                                         '[OpenAI 프롬프트]',
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 14,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 8),
//                                       SelectableText(
//                                         prompt,
//                                         style: const TextStyle(
//                                           fontSize: 13,
//                                           height: 1.4,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () =>
//                                       Navigator.of(context).pop(),
//                                   child: const Text('닫기'),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       } catch (e) {
//                         if (!mounted) return;
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content:
//                                 Text('텍스트 추출 중 오류가 발생했습니다: $e'),
//                             duration: const Duration(seconds: 2),
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 SizedBox(
//                   width: double.infinity,
//                   child: OutlinedButton(
//                     child: const Text(
//                       '전체 복습 콘텐츠 보기 (향후)',
//                       style: TextStyle(fontSize: 12),
//                     ),
//                     onPressed: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('복습 콘텐츠 화면은 추후 구현 예정입니다.'),
//                           duration: Duration(seconds: 1),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   static Widget _buildHistoryPlaceholder({
//     required String title,
//     required String description,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: const Color(0xFFFFFFFF),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Color(0xFFE0E0E0)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 12,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             description,
//             style: const TextStyle(
//               fontSize: 11,
//               color: Colors.black54,
//               height: 1.3,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // -----------------------------
//   // 화면 전체 빌드
//   // -----------------------------
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Study Highlight PDF'),
//         centerTitle: true,
//         bottom: _buildTopToolbar(),
//       ),
//       body: Row(
//         children: [
//           Expanded(
//             child: Stack(
//               children: [
//                 Positioned.fill(
//                   child: PDFView(
//                     filePath: widget.path,
//                     enableSwipe: true,
//                     swipeHorizontal: true,
//                     autoSpacing: true,
//                     pageFling: true,
//                     onRender: (pages) {
//                       setState(() {
//                         _totalPages = pages ?? 0;
//                       });
//                     },
//                     onPageChanged: (page, total) {
//                       setState(() {
//                         _currentPage = page ?? 0;
//                       });
//                     },
//                   ),
//                 ),
//                 Positioned.fill(
//                   child: RepaintBoundary(
//                     key: _canvasKey,
//                     child: GestureDetector(
//                       behavior: HitTestBehavior.translucent,
//                       onPanStart: _onPanStart,
//                       onPanUpdate: _onPanUpdate,
//                       onPanEnd: _onPanEnd,
//                       child: CustomPaint(
//                         painter: DrawingPainter(_strokes),
//                         size: Size.infinite,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           _buildRightAiPanel(),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:flutter_pdf_text/flutter_pdf_text.dart';
//
// void main() {
//   runApp(const StudyHighlightApp());
// }
//
// class StudyHighlightApp extends StatelessWidget {
//   const StudyHighlightApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Study Highlight',
//       debugShowCheckedModeBanner: false,
//       home: const StudyHomePage(),
//     );
//   }
// }
//
// /// 홈 화면: PDF 선택
// class StudyHomePage extends StatelessWidget {
//   const StudyHomePage({super.key});
//
//   Future<void> _openPdf(BuildContext context) async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );
//
//     if (result == null || result.files.single.path == null) return;
//
//     final path = result.files.single.path!;
//
//     Navigator.of(context).push(
//       MaterialPageRoute(builder: (_) => PDFDrawScreen(path: path)),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(
//         title: const Text('Study Highlight 노트'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.note_alt_outlined, size: 80),
//             const SizedBox(height: 16),
//             const Text(
//               'PDF를 선택해서 공부를 시작하세요.',
//               style: TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () => _openPdf(context),
//               child: const Text('PDF 열기'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // -----------------------------
// // PDF 텍스트 추출용 리포지토리
// // -----------------------------
//
// class PdfTextRepository {
//   PDFDoc? _doc;
//
//   Future<void> load(String path) async {
//     _doc = await PDFDoc.fromPath(path);
//   }
//
//   Future<String> getPageText(int pageIndex) async {
//     final doc = _doc;
//     if (doc == null) {
//       throw Exception('PDF 텍스트 문서를 아직 로드하지 않았습니다.');
//     }
//
//     // flutter_pdf_text 는 1-based 페이지 인덱스 사용
//     final page = await doc.pageAt(pageIndex + 1);
//     final text = await page.text;
//     return text;
//   }
// }
//
// // -----------------------------
// // 드로잉 관련 모델
// // -----------------------------
//
// enum DrawTool {
//   pen,
//   highlighter,
//   eraser,
// }
//
// class Stroke {
//   Stroke({
//     required this.points,
//     required this.color,
//     required this.width,
//     required this.tool,
//   });
//
//   final List<Offset> points;
//   final Color color;
//   final double width;
//   final DrawTool tool;
// }
//
// /// 형광펜 Stroke를 기반으로 만든 "하이라이트 영역"
// class HighlightRegion {
//   HighlightRegion({
//     required this.page,
//     required this.rectNormalized,
//     required this.color,
//   });
//
//   final int page; // 0 기반 현재 페이지
//   final Rect rectNormalized; // 0~1 로 정규화된 좌표
//   final Color color;
//
//   Map<String, dynamic> toJson() {
//     return {
//       'page': page,
//       'rect': {
//         'left': rectNormalized.left,
//         'top': rectNormalized.top,
//         'right': rectNormalized.right,
//         'bottom': rectNormalized.bottom,
//       },
//       'color': color.value.toRadixString(16),
//     };
//   }
//
//   @override
//   String toString() => toJson().toString();
// }
//
// /// 한 줄(or 블록)에 해당하는 텍스트와 그 위치 정보
// class TextRegion {
//   final Rect rectNormalized; // 0~1 기준
//   final String text;
//
//   TextRegion({
//     required this.rectNormalized,
//     required this.text,
//   });
// }
//
// /// 페이지 텍스트를 TextRegion 리스트로 바꿔주는 헬퍼
// /// (일단은 "줄 단위로 위에서 아래로 쭉 나눈다"는 1차 버전)
// class PageTextLayoutService {
//   List<TextRegion> buildRegions({
//     required String pageText,
//     required Size pageSize,
//   }) {
//     final lines = pageText.split('\n');
//     final regions = <TextRegion>[];
//
//     if (lines.isEmpty || pageSize.height <= 0) {
//       return regions;
//     }
//
//     final lineCount = lines.length;
//     final lineHeight = pageSize.height / lineCount;
//
//     for (var i = 0; i < lineCount; i++) {
//       final text = lines[i].trim();
//       if (text.isEmpty) continue;
//
//       final top = i * lineHeight;
//       final rect = Rect.fromLTWH(0, top, pageSize.width, lineHeight);
//
//       final rectNormalized = Rect.fromLTWH(
//         rect.left / pageSize.width,
//         rect.top / pageSize.height,
//         rect.width / pageSize.width,
//         rect.height / pageSize.height,
//       );
//
//       regions.add(
//         TextRegion(
//           rectNormalized: rectNormalized,
//           text: text,
//         ),
//       );
//     }
//
//     return regions;
//   }
// }
//
// // -----------------------------
// // Stroke 리스트를 그리는 Painter
// // -----------------------------
//
// class DrawingPainter extends CustomPainter {
//   final List<Stroke> strokes;
//
//   DrawingPainter(this.strokes);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     for (final stroke in strokes) {
//       if (stroke.points.length < 2) continue;
//
//       final paint = Paint()
//         ..color = (stroke.tool == DrawTool.highlighter)
//             ? stroke.color.withOpacity(0.7)
//             : stroke.color
//         ..strokeWidth = stroke.width
//         ..strokeCap = StrokeCap.round
//         ..strokeJoin = StrokeJoin.round
//         ..style = PaintingStyle.stroke;
//
//       for (int i = 0; i < stroke.points.length - 1; i++) {
//         final p1 = stroke.points[i];
//         final p2 = stroke.points[i + 1];
//         canvas.drawLine(p1, p2, paint);
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant DrawingPainter oldDelegate) {
//     return true;
//   }
// }
//
// // -----------------------------
// // PDF + 드로잉 + 상단 툴바 + 오른쪽 AI 패널 화면
// // -----------------------------
// class PDFDrawScreen extends StatefulWidget {
//   final String path;
//   const PDFDrawScreen({super.key, required this.path});
//
//   @override
//   State<PDFDrawScreen> createState() => _PDFDrawScreenState();
// }
//
// class _PDFDrawScreenState extends State<PDFDrawScreen> {
//   final List<Stroke> _strokes = [];
//   final List<Stroke> _redoStack = [];
//
//   Stroke? _currentStroke;
//
//   // 현재 도구/색상/두께
//   DrawTool _tool = DrawTool.highlighter;
//   Color _currentColor = Colors.yellowAccent;
//   double _currentWidth = 16.0;
//
//   // PDF 페이지 상태
//   int _currentPage = 0;
//   int _totalPages = 0;
//
//   // 형광펜 하이라이트 영역 리스트
//   final List<HighlightRegion> _highlights = [];
//
//   // 캔버스 영역 기준 좌표 변환용 키
//   final GlobalKey _canvasKey = GlobalKey();
//
//   // PDF 텍스트 및 레이아웃 캐시
//   final PdfTextRepository _pdfTextRepository = PdfTextRepository();
//   final PageTextLayoutService _pageTextLayoutService = PageTextLayoutService();
//   final Map<int, List<TextRegion>> _pageRegionsCache = {}; // pageIndex → regions
//
//   @override
//   void initState() {
//     super.initState();
//     _initPdfText();
//   }
//
//   Future<void> _initPdfText() async {
//     try {
//       await _pdfTextRepository.load(widget.path);
//       debugPrint('PDF 텍스트 로드 완료');
//     } catch (e) {
//       debugPrint('PDF 텍스트 로드 실패: $e');
//     }
//   }
//
//   // -----------------------------
//   // 헬퍼: 색상 → 태그 레이블
//   // -----------------------------
//   String get _currentTagLabel {
//     if (_currentColor.value == Colors.yellowAccent.value) {
//       return '복습(Review)';
//     } else if (_currentColor.value == Colors.lightBlueAccent.value) {
//       return '심화(Deep)';
//     } else if (_currentColor.value == Colors.pinkAccent.value) {
//       return '예제(Example)';
//     } else if (_currentColor.value == Colors.greenAccent.value) {
//       return '정리(Summary)';
//     } else if (_currentColor.value == Colors.orangeAccent.value) {
//       return '기타(Custom)';
//     } else {
//       return '태그 미지정';
//     }
//   }
//
//   // -----------------------------
//   // 드로잉 로직
//   // -----------------------------
//
//   Offset _toLocal(Offset globalPosition) {
//     final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
//     if (box == null) return globalPosition;
//     return box.globalToLocal(globalPosition);
//   }
//
//   void _onPanStart(DragStartDetails details) {
//     final pos = _toLocal(details.globalPosition);
//
//     // 지우개 모드: Stroke 제거
//     if (_tool == DrawTool.eraser) {
//       _eraseAt(pos);
//       return;
//     }
//
//     final width = (_tool == DrawTool.highlighter)
//         ? _currentWidth
//         : (_currentWidth / 1.8).clamp(2.0, 12.0);
//
//     _currentStroke = Stroke(
//       points: [pos],
//       color: _currentColor,
//       width: width,
//       tool: _tool,
//     );
//
//     setState(() {
//       _strokes.add(_currentStroke!);
//       _redoStack.clear();
//     });
//   }
//
//   void _onPanUpdate(DragUpdateDetails details) {
//     final pos = _toLocal(details.globalPosition);
//
//     if (_tool == DrawTool.eraser) {
//       _eraseAt(pos);
//       return;
//     }
//
//     if (_currentStroke == null) return;
//
//     setState(() {
//       _currentStroke!.points.add(pos);
//     });
//   }
//
//   void _onPanEnd(DragEndDetails details) {
//     if (_currentStroke != null && _currentStroke!.tool == DrawTool.highlighter) {
//       _saveHighlightFromStroke(_currentStroke!);
//     }
//     _currentStroke = null;
//   }
//
//   // Stroke → HighlightRegion 변환
//   void _saveHighlightFromStroke(Stroke stroke) {
//     if (stroke.points.length < 2) return;
//
//     final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
//     if (box == null) return;
//
//     final size = box.size;
//
//     double minX = stroke.points.first.dx;
//     double maxX = stroke.points.first.dx;
//     double minY = stroke.points.first.dy;
//     double maxY = stroke.points.first.dy;
//
//     for (final p in stroke.points) {
//       if (p.dx < minX) minX = p.dx;
//       if (p.dx > maxX) maxX = p.dx;
//       if (p.dy < minY) minY = p.dy;
//       if (p.dy > maxY) maxY = p.dy;
//     }
//
//     const padding = 4.0;
//     minX = (minX - padding).clamp(0.0, size.width);
//     maxX = (maxX + padding).clamp(0.0, size.width);
//     minY = (minY - padding).clamp(0.0, size.height);
//     maxY = (maxY + padding).clamp(0.0, size.height);
//
//     final rect = Rect.fromLTRB(minX, minY, maxX, maxY);
//
//     final normalized = Rect.fromLTRB(
//       rect.left / size.width,
//       rect.top / size.height,
//       rect.right / size.width,
//       rect.bottom / size.height,
//     );
//
//     final region = HighlightRegion(
//       page: _currentPage,
//       rectNormalized: normalized,
//       color: stroke.color,
//     );
//
//     setState(() {
//       _highlights.add(region);
//     });
//
//     debugPrint('New highlight: $region');
//   }
//
//   // 지우개: 현재 위치 근처에 있는 Stroke를 제거
//   void _eraseAt(Offset pos) {
//     const double threshold = 20.0;
//
//     setState(() {
//       _strokes.removeWhere((stroke) {
//         return stroke.points.any(
//           (p) => (p - pos).distance <= threshold,
//         );
//       });
//
//       _highlights.removeWhere((region) {
//         final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
//         if (box == null) return false;
//         final size = box.size;
//
//         final rect = Rect.fromLTRB(
//           region.rectNormalized.left * size.width,
//           region.rectNormalized.top * size.height,
//           region.rectNormalized.right * size.width,
//           region.rectNormalized.bottom * size.height,
//         );
//         final center = rect.center;
//         return (center - pos).distance <= threshold;
//       });
//     });
//   }
//
//   // Undo / Redo / Clear
//   void _undo() {
//     if (_strokes.isEmpty) return;
//     setState(() {
//       final last = _strokes.removeLast();
//       _redoStack.add(last);
//       if (_highlights.isNotEmpty) {
//         _highlights.removeLast();
//       }
//     });
//   }
//
//   void _redo() {
//     if (_redoStack.isEmpty) return;
//     setState(() {
//       final stroke = _redoStack.removeLast();
//       _strokes.add(stroke);
//     });
//   }
//
//   void _clearAll() {
//     setState(() {
//       _strokes.clear();
//       _redoStack.clear();
//       _highlights.clear();
//     });
//   }
//
//   // -----------------------------
//   // TextRegion 관련 헬퍼
//   // -----------------------------
//   Future<List<TextRegion>> _getRegionsForPage(int pageIndex) async {
//     if (_pageRegionsCache.containsKey(pageIndex)) {
//       return _pageRegionsCache[pageIndex]!;
//     }
//
//     final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
//     if (box == null) {
//       throw Exception('캔버스 RenderBox를 찾을 수 없습니다.');
//     }
//     final pageSize = box.size;
//
//     final pageText = await _pdfTextRepository.getPageText(pageIndex);
//
//     final regions = _pageTextLayoutService.buildRegions(
//       pageText: pageText,
//       pageSize: pageSize,
//     );
//
//     _pageRegionsCache[pageIndex] = regions;
//     return regions;
//   }
//
//   String _extractTextForHighlight({
//     required Rect highlightRectNormalized,
//     required List<TextRegion> regions,
//   }) {
//     final buffer = StringBuffer();
//
//     for (final region in regions) {
//       if (highlightRectNormalized.overlaps(region.rectNormalized)) {
//         buffer.writeln(region.text.trim());
//       }
//     }
//
//     return buffer.toString().trim();
//   }
//
//   /// 특정 색상의 하이라이트 텍스트를 전 페이지에서 모아서 하나의 문자열로 합치기
//   Future<String> _collectHighlightTextByColor(Color targetColor) async {
//     if (_highlights.isEmpty) {
//       return '';
//     }
//
//     final filtered =
//         _highlights.where((h) => h.color.value == targetColor.value).toList();
//
//     if (filtered.isEmpty) {
//       return '';
//     }
//
//     final buffer = StringBuffer();
//
//     final byPage = <int, List<HighlightRegion>>{};
//     for (final h in filtered) {
//       byPage.putIfAbsent(h.page, () => []).add(h);
//     }
//
//     for (final entry in byPage.entries) {
//       final pageIndex = entry.key;
//       final pageHighlights = entry.value;
//
//       final regions = await _getRegionsForPage(pageIndex);
//
//       buffer.writeln('===== Page ${pageIndex + 1} =====');
//
//       for (final h in pageHighlights) {
//         final text = _extractTextForHighlight(
//           highlightRectNormalized: h.rectNormalized,
//           regions: regions,
//         );
//
//         if (text.isNotEmpty) {
//           buffer.writeln(text);
//           buffer.writeln();
//         }
//       }
//
//       buffer.writeln();
//     }
//
//     return buffer.toString().trim();
//   }
//
//   // -----------------------------
//   // OpenAI 프롬프트 생성
//   // -----------------------------
//   String _buildOpenAIPrompt(String highlightText) {
//     return '''
// You are a helpful study assistant. Summarize and organize the following highlighted textbook content into Korean study notes.
//
// [하이라이트 원문]
// $highlightText
//
// 요청:
//
// 1. 핵심 개념을 항목별로 정리해 주세요.
// 2. 시험에 나올만한 포인트는 별표(*)를 붙여 강조해 주세요.
// 3. 필요한 경우 간단한 예시를 덧붙여 주세요.
// 4. 전체 분량은 A4 한 페이지를 넘지 않게 요약해 주세요.
// ''';
//   }
//
//   // -----------------------------
//   // 상단 툴바
//   // -----------------------------
//   Widget _buildToolButton({
//     required IconData icon,
//     required DrawTool tool,
//   }) {
//     final isSelected = _tool == tool;
//     return IconButton(
//       tooltip: tool == DrawTool.pen
//           ? '펜'
//           : tool == DrawTool.highlighter
//               ? '형광펜'
//               : '지우개',
//       icon: Icon(
//         icon,
//         color: isSelected ? Colors.blueAccent : Colors.black54,
//       ),
//       onPressed: () {
//         setState(() {
//           _tool = tool;
//         });
//       },
//     );
//   }
//
//   Widget _buildColorDot(Color color) {
//     final selected =
//         _currentColor.value == color.value && _tool == DrawTool.highlighter;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _currentColor = color;
//           if (_tool == DrawTool.eraser) {
//             _tool = DrawTool.highlighter;
//           }
//         });
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 4),
//         width: selected ? 26 : 22,
//         height: selected ? 26 : 22,
//         decoration: BoxDecoration(
//           color: color,
//           shape: BoxShape.circle,
//           border: Border.all(
//             color: selected ? Colors.black87 : Colors.black26,
//             width: selected ? 2 : 1,
//           ),
//         ),
//       ),
//     );
//   }
//
//   PreferredSizeWidget _buildTopToolbar() {
//     return PreferredSize(
//       preferredSize: const Size.fromHeight(72),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 4,
//               offset: Offset(0, 1),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 IconButton(
//                   tooltip: '줌 (추후 구현 예정)',
//                   icon: const Icon(Icons.search),
//                   onPressed: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('줌 기능은 나중에 구현할 예정입니다.'),
//                         duration: Duration(seconds: 1),
//                       ),
//                     );
//                   },
//                 ),
//                 _buildToolButton(icon: Icons.edit, tool: DrawTool.pen),
//                 _buildToolButton(
//                     icon: Icons.border_color, tool: DrawTool.highlighter),
//                 _buildToolButton(
//                     icon: Icons.auto_fix_normal, tool: DrawTool.eraser),
//                 const SizedBox(width: 8),
//                 IconButton(
//                   tooltip: '선택 도구 (추후 구현 예정)',
//                   icon: const Icon(Icons.all_inclusive),
//                   onPressed: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('선택 도구는 나중에 구현할 예정입니다.'),
//                         duration: Duration(seconds: 1),
//                       ),
//                     );
//                   },
//                 ),
//                 IconButton(
//                   tooltip: '도형 (추후 구현 예정)',
//                   icon: const Icon(Icons.crop_square),
//                   onPressed: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('도형 기능은 나중에 구현할 예정입니다.'),
//                         duration: Duration(seconds: 1),
//                       ),
//                     );
//                   },
//                 ),
//                 const Spacer(),
//                 IconButton(
//                   tooltip: '되돌리기',
//                   icon: const Icon(Icons.undo),
//                   onPressed: _undo,
//                 ),
//                 IconButton(
//                   tooltip: '다시 실행',
//                   icon: const Icon(Icons.redo),
//                   onPressed: _redo,
//                 ),
//                 IconButton(
//                   tooltip: '전체 지우기',
//                   icon: const Icon(Icons.delete_outline),
//                   onPressed: _clearAll,
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 _buildColorDot(Colors.yellowAccent),
//                 _buildColorDot(Colors.lightBlueAccent),
//                 _buildColorDot(Colors.pinkAccent),
//                 _buildColorDot(Colors.greenAccent),
//                 _buildColorDot(Colors.orangeAccent),
//                 const SizedBox(width: 12),
//                 const Text(
//                   '두께',
//                   style: TextStyle(fontSize: 12),
//                 ),
//                 Expanded(
//                   child: Slider(
//                     value: _currentWidth,
//                     min: 4,
//                     max: 28,
//                     divisions: 12,
//                     onChanged: (value) {
//                       setState(() {
//                         _currentWidth = value;
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // -----------------------------
//   // 오른쪽 AI 패널 UI
//   // -----------------------------
//   Widget _buildRightAiPanel() {
//     final currentPageHighlights =
//         _highlights.where((h) => h.page == _currentPage).toList();
//     return Container(
//       width: 320,
//       decoration: const BoxDecoration(
//         color: Color(0xFFF7F8FA),
//         border: Border(
//           left: BorderSide(color: Color(0xFFDDDDDD)),
//         ),
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding:
//                 const EdgeInsets.only(top: 12, bottom: 8, left: 16, right: 16),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 3,
//                   offset: Offset(0, 1),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'AI 학습 패널',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Row(
//                   children: [
//                     Container(
//                       width: 10,
//                       height: 10,
//                       margin: const EdgeInsets.only(right: 6),
//                       decoration: BoxDecoration(
//                         color: _currentColor,
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.black26),
//                       ),
//                     ),
//                     Expanded(
//                       child: Text(
//                         '현재 태그: $_currentTagLabel',
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Colors.black87,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '현재 페이지: ${_currentPage + 1} / $_totalPages, '
//                   '하이라이트 ${currentPageHighlights.length}개',
//                   style: const TextStyle(
//                     fontSize: 11,
//                     color: Colors.black54,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//               child: ListView(
//                 children: [
//                   const SizedBox(height: 8),
//                   const Text(
//                     '하이라이트 좌표 (디버그 용)',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 13,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   if (currentPageHighlights.isEmpty)
//                     Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: Color(0xFFDDDDDD)),
//                       ),
//                       child: const Text(
//                         '이 페이지에서 형광펜으로 문장을 긋고 나면, '
//                         '정규화된 좌표 정보가 여기에 표시됩니다.',
//                         style: TextStyle(fontSize: 12, height: 1.4),
//                       ),
//                     )
//                   else
//                     ...currentPageHighlights.map((h) {
//                       final r = h.rectNormalized;
//                       return Container(
//                         margin: const EdgeInsets.only(bottom: 6),
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(6),
//                           border: Border.all(color: const Color(0xFFE0E0E0)),
//                         ),
//                         child: Text(
//                           'page=${h.page}, '
//                           'left=${r.left.toStringAsFixed(3)}, '
//                           'top=${r.top.toStringAsFixed(3)}, '
//                           'right=${r.right.toStringAsFixed(3)}, '
//                           'bottom=${r.bottom.toStringAsFixed(3)}',
//                           style: const TextStyle(
//                             fontSize: 11,
//                             height: 1.3,
//                           ),
//                         ),
//                       );
//                     }),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'AI 작업 히스토리 (향후)',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 13,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   _buildHistoryPlaceholder(
//                     title: '복습 요약',
//                     description: '노랑 태그로 긋는 구간이 여기에 쌓일 예정입니다.',
//                   ),
//                   const SizedBox(height: 8),
//                   _buildHistoryPlaceholder(
//                     title: '심화 설명',
//                     description: '하늘 태그로 긋는 구간의 심화 설명이 저장됩니다.',
//                   ),
//                   const SizedBox(height: 8),
//                   _buildHistoryPlaceholder(
//                     title: '예제/문제',
//                     description: '예제 태그를 기반으로 자동 문제가 생성됩니다.',
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               border: Border(
//                 top: BorderSide(color: Color(0xFFDDDDDD)),
//               ),
//             ),
//             child: Column(
//               children: [
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton.icon(
//                     icon: const Icon(Icons.code, size: 18),
//                     label: const Text(
//                       '하이라이트 JSON 로그',
//                       style: TextStyle(fontSize: 13),
//                     ),
//                     onPressed: () {
//                       for (final h in _highlights) {
//                         debugPrint(h.toString());
//                       }
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content:
//                               Text('디버그 콘솔에서 하이라이트 정보를 확인할 수 있습니다.'),
//                           duration: Duration(seconds: 1),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton.icon(
//                     icon: const Icon(Icons.highlight, size: 18),
//                     label: const Text(
//                       '노랑 하이라이트 텍스트 보기',
//                       style: TextStyle(fontSize: 13),
//                     ),
//                     onPressed: () async {
//                       try {
//                         final result = await _collectHighlightTextByColor(
//                           Colors.yellowAccent,
//                         );
//
//                         if (!mounted) return;
//
//                         if (result.isEmpty) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content:
//                                   Text('노랑 하이라이트에 매핑된 텍스트가 없습니다.'),
//                               duration: Duration(seconds: 1),
//                             ),
//                           );
//                           return;
//                         }
//
//                         await showDialog(
//                           context: context,
//                           builder: (context) {
//                             return AlertDialog(
//                               title: const Text('노랑 하이라이트 텍스트'),
//                               content: SizedBox(
//                                 width: double.maxFinite,
//                                 child: SingleChildScrollView(
//                                   child: Text(
//                                     result,
//                                     style: const TextStyle(
//                                       fontSize: 13,
//                                       height: 1.4,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () =>
//                                       Navigator.of(context).pop(),
//                                   child: const Text('닫기'),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       } catch (e) {
//                         if (!mounted) return;
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content:
//                                 Text('텍스트 추출 중 오류가 발생했습니다: $e'),
//                             duration: const Duration(seconds: 2),
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton.icon(
//                     icon: const Icon(Icons.send, size: 18),
//                     label: const Text(
//                       'OpenAI 프롬프트 형식으로 보기',
//                       style: TextStyle(fontSize: 13),
//                     ),
//                     onPressed: () async {
//                       try {
//                         final highlightText =
//                             await _collectHighlightTextByColor(
//                           Colors.yellowAccent,
//                         );
//
//                         if (!mounted) return;
//
//                         if (highlightText.isEmpty) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content:
//                                   Text('노랑 하이라이트에 매핑된 텍스트가 없습니다.'),
//                               duration: Duration(seconds: 1),
//                             ),
//                           );
//                           return;
//                         }
//
//                         final prompt = _buildOpenAIPrompt(highlightText);
//
//                         await showDialog(
//                           context: context,
//                           builder: (context) {
//                             return AlertDialog(
//                               title: const Text(
//                                   '노랑 하이라이트 텍스트 / OpenAI 프롬프트'),
//                               content: SizedBox(
//                                 width: double.maxFinite,
//                                 child: SingleChildScrollView(
//                                   child: Text(
//                                     prompt,
//                                     style: const TextStyle(
//                                       fontSize: 12,
//                                       height: 1.4,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () =>
//                                       Navigator.of(context).pop(),
//                                   child: const Text('닫기'),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       } catch (e) {
//                         if (!mounted) return;
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content:
//                                 Text('프롬프트 생성 중 오류가 발생했습니다: $e'),
//                             duration: const Duration(seconds: 2),
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 SizedBox(
//                   width: double.infinity,
//                   child: OutlinedButton(
//                     child: const Text(
//                       '전체 복습 콘텐츠 보기 (향후)',
//                       style: TextStyle(fontSize: 12),
//                     ),
//                     onPressed: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('복습 콘텐츠 화면은 추후 구현 예정입니다.'),
//                           duration: Duration(seconds: 1),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHistoryPlaceholder({
//     required String title,
//     required String description,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: const Color(0xFFFFFFFF),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: const Color(0xFFE0E0E0)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 12,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             description,
//             style: const TextStyle(
//               fontSize: 11,
//               color: Colors.black54,
//               height: 1.3,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // -----------------------------
//   // 화면 전체 빌드
//   // -----------------------------
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Study Highlight PDF'),
//         centerTitle: true,
//         bottom: _buildTopToolbar(),
//       ),
//       body: Row(
//         children: [
//           Expanded(
//             child: Stack(
//               children: [
//                 Positioned.fill(
//                   child: PDFView(
//                     filePath: widget.path,
//                     enableSwipe: true,
//                     swipeHorizontal: true,
//                     autoSpacing: true,
//                     pageFling: true,
//                     onRender: (pages) {
//                       setState(() {
//                         _totalPages = pages ?? 0;
//                       });
//                     },
//                     onPageChanged: (page, total) {
//                       setState(() {
//                         _currentPage = page ?? 0;
//                       });
//                     },
//                   ),
//                 ),
//                 Positioned.fill(
//                   child: RepaintBoundary(
//                     key: _canvasKey,
//                     child: GestureDetector(
//                       behavior: HitTestBehavior.translucent,
//                       onPanStart: _onPanStart,
//                       onPanUpdate: _onPanUpdate,
//                       onPanEnd: _onPanEnd,
//                       child: CustomPaint(
//                         painter: DrawingPainter(_strokes),
//                         size: Size.infinite,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           _buildRightAiPanel(),
//         ],
//       ),
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_pdf_text/flutter_pdf_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() {
  runApp(const StudyHighlightApp());
}

class StudyHighlightApp extends StatelessWidget {
  const StudyHighlightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Highlight',
      debugShowCheckedModeBanner: false,
      home: const StudyHomePage(),
    );
  }
}

/// 홈 화면: PDF 선택
class StudyHomePage extends StatelessWidget {
  const StudyHomePage({super.key});

  Future<void> _openPdf(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null || result.files.single.path == null) return;

    final path = result.files.single.path!;

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PDFDrawScreen(path: path)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Study Highlight 노트'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.note_alt_outlined, size: 80),
            const SizedBox(height: 16),
            const Text(
              'PDF를 선택해서 공부를 시작하세요.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _openPdf(context),
              child: const Text('PDF 열기'),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------
// PDF 텍스트 추출용 리포지토리
// -----------------------------

class PdfTextRepository {
  PDFDoc? _doc;

  Future<void> load(String path) async {
    _doc = await PDFDoc.fromPath(path);
  }

  Future<String> getPageText(int pageIndex) async {
    final doc = _doc;
    if (doc == null) {
      throw Exception('PDF 텍스트 문서를 아직 로드하지 않았습니다.');
    }

    // flutter_pdf_text 는 1-based 페이지 인덱스 사용
    final page = await doc.pageAt(pageIndex + 1);
    final text = await page.text;
    return text;
  }
}

// -----------------------------
// 드로잉 관련 모델
// -----------------------------

enum DrawTool {
  pen,
  highlighter,
  eraser,
}

class Stroke {
  Stroke({
    required this.points,
    required this.color,
    required this.width,
    required this.tool,
  });

  final List<Offset> points;
  final Color color;
  final double width;
  final DrawTool tool;
}

/// 형광펜 Stroke를 기반으로 만든 "하이라이트 영역"
class HighlightRegion {
  HighlightRegion({
    required this.page,
    required this.rectNormalized,
    required this.color,
  });

  final int page; // 0 기반 현재 페이지
  final Rect rectNormalized; // 0~1 로 정규화된 좌표
  final Color color;

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'rect': {
        'left': rectNormalized.left,
        'top': rectNormalized.top,
        'right': rectNormalized.right,
        'bottom': rectNormalized.bottom,
      },
      'color': color.value.toRadixString(16),
    };
  }

  @override
  String toString() => toJson().toString();
}

/// 한 줄(or 블록)에 해당하는 텍스트와 그 위치 정보
class TextRegion {
  final Rect rectNormalized; // 0~1 기준
  final String text;

  TextRegion({
    required this.rectNormalized,
    required this.text,
  });
}

/// 페이지 텍스트를 TextRegion 리스트로 바꿔주는 헬퍼
/// (일단은 "줄 단위로 위에서 아래로 쭉 나눈다"는 1차 버전)
class PageTextLayoutService {
  List<TextRegion> buildRegions({
    required String pageText,
    required Size pageSize,
  }) {
    final lines = pageText.split('\n');
    final regions = <TextRegion>[];

    if (lines.isEmpty || pageSize.height <= 0) {
      return regions;
    }

    final lineCount = lines.length;
    final lineHeight = pageSize.height / lineCount;

    for (var i = 0; i < lineCount; i++) {
      final text = lines[i].trim();
      if (text.isEmpty) continue;

      final top = i * lineHeight;
      final rect = Rect.fromLTWH(0, top, pageSize.width, lineHeight);

      final rectNormalized = Rect.fromLTWH(
        rect.left / pageSize.width,
        rect.top / pageSize.height,
        rect.width / pageSize.width,
        rect.height / pageSize.height,
      );

      regions.add(
        TextRegion(
          rectNormalized: rectNormalized,
          text: text,
        ),
      );
    }

    return regions;
  }
}

// -----------------------------
// Stroke 리스트를 그리는 Painter
// -----------------------------

class DrawingPainter extends CustomPainter {
  final List<Stroke> strokes;

  DrawingPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      if (stroke.points.length < 2) continue;

      final paint = Paint()
        ..color = (stroke.tool == DrawTool.highlighter)
            ? stroke.color.withOpacity(0.7)
            : stroke.color
        ..strokeWidth = stroke.width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      for (int i = 0; i < stroke.points.length - 1; i++) {
        final p1 = stroke.points[i];
        final p2 = stroke.points[i + 1];
        canvas.drawLine(p1, p2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    return true;
  }
}

// -----------------------------
// PDF + 드로잉 + 상단 툴바 + 오른쪽 AI 패널 화면
// -----------------------------
class PDFDrawScreen extends StatefulWidget {
  final String path;
  const PDFDrawScreen({super.key, required this.path});

  @override
  State<PDFDrawScreen> createState() => _PDFDrawScreenState();
}

class _PDFDrawScreenState extends State<PDFDrawScreen> {
  final List<Stroke> _strokes = [];
  final List<Stroke> _redoStack = [];

  Stroke? _currentStroke;

  // 현재 도구/색상/두께
  DrawTool _tool = DrawTool.highlighter;
  Color _currentColor = Colors.yellowAccent;
  double _currentWidth = 16.0;

  // PDF 페이지 상태
  int _currentPage = 0;
  int _totalPages = 0;

  // 형광펜 하이라이트 영역 리스트
  final List<HighlightRegion> _highlights = [];

  // 캔버스 영역 기준 좌표 변환용 키
  final GlobalKey _canvasKey = GlobalKey();

  // PDF 텍스트 및 레이아웃 캐시
  final PdfTextRepository _pdfTextRepository = PdfTextRepository();
  final PageTextLayoutService _pageTextLayoutService = PageTextLayoutService();
  final Map<int, List<TextRegion>> _pageRegionsCache = {}; // pageIndex → regions

  @override
  void initState() {
    super.initState();
    _initPdfText();
  }

  Future<void> _initPdfText() async {
    try {
      await _pdfTextRepository.load(widget.path);
      debugPrint('PDF 텍스트 로드 완료');
    } catch (e) {
      debugPrint('PDF 텍스트 로드 실패: $e');
    }
  }

  // -----------------------------
  // 헬퍼: 색상 → 태그 레이블
  // -----------------------------
  String get _currentTagLabel {
    if (_currentColor.value == Colors.yellowAccent.value) {
      return '복습(Review)';
    } else if (_currentColor.value == Colors.lightBlueAccent.value) {
      return '심화(Deep)';
    } else if (_currentColor.value == Colors.pinkAccent.value) {
      return '예제(Example)';
    } else if (_currentColor.value == Colors.greenAccent.value) {
      return '정리(Summary)';
    } else if (_currentColor.value == Colors.orangeAccent.value) {
      return '기타(Custom)';
    } else {
      return '태그 미지정';
    }
  }

  // -----------------------------
  // 드로잉 로직
  // -----------------------------

  Offset _toLocal(Offset globalPosition) {
    final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return globalPosition;
    return box.globalToLocal(globalPosition);
  }

  void _onPanStart(DragStartDetails details) {
    final pos = _toLocal(details.globalPosition);

    // 지우개 모드: Stroke 제거
    if (_tool == DrawTool.eraser) {
      _eraseAt(pos);
      return;
    }

    final width = (_tool == DrawTool.highlighter)
        ? _currentWidth
        : (_currentWidth / 1.8).clamp(2.0, 12.0);

    _currentStroke = Stroke(
      points: [pos],
      color: _currentColor,
      width: width,
      tool: _tool,
    );

    setState(() {
      _strokes.add(_currentStroke!);
      _redoStack.clear();
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final pos = _toLocal(details.globalPosition);

    if (_tool == DrawTool.eraser) {
      _eraseAt(pos);
      return;
    }

    if (_currentStroke == null) return;

    setState(() {
      _currentStroke!.points.add(pos);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_currentStroke != null && _currentStroke!.tool == DrawTool.highlighter) {
      _saveHighlightFromStroke(_currentStroke!);
    }
    _currentStroke = null;
  }

  // Stroke → HighlightRegion 변환
  void _saveHighlightFromStroke(Stroke stroke) {
    if (stroke.points.length < 2) return;

    final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final size = box.size;

    double minX = stroke.points.first.dx;
    double maxX = stroke.points.first.dx;
    double minY = stroke.points.first.dy;
    double maxY = stroke.points.first.dy;

    for (final p in stroke.points) {
      if (p.dx < minX) minX = p.dx;
      if (p.dx > maxX) maxX = p.dx;
      if (p.dy < minY) minY = p.dy;
      if (p.dy > maxY) maxY = p.dy;
    }

    const padding = 4.0;
    minX = (minX - padding).clamp(0.0, size.width);
    maxX = (maxX + padding).clamp(0.0, size.width);
    minY = (minY - padding).clamp(0.0, size.height);
    maxY = (maxY + padding).clamp(0.0, size.height);

    final rect = Rect.fromLTRB(minX, minY, maxX, maxY);

    final normalized = Rect.fromLTRB(
      rect.left / size.width,
      rect.top / size.height,
      rect.right / size.width,
      rect.bottom / size.height,
    );

    final region = HighlightRegion(
      page: _currentPage,
      rectNormalized: normalized,
      color: stroke.color,
    );

    setState(() {
      _highlights.add(region);
    });

    debugPrint('New highlight: $region');
  }

  // 지우개: 현재 위치 근처에 있는 Stroke를 제거
  void _eraseAt(Offset pos) {
    const double threshold = 20.0;

    setState(() {
      _strokes.removeWhere((stroke) {
        return stroke.points.any(
          (p) => (p - pos).distance <= threshold,
        );
      });

      _highlights.removeWhere((region) {
        final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
        if (box == null) return false;
        final size = box.size;

        final rect = Rect.fromLTRB(
          region.rectNormalized.left * size.width,
          region.rectNormalized.top * size.height,
          region.rectNormalized.right * size.width,
          region.rectNormalized.bottom * size.height,
        );
        final center = rect.center;
        return (center - pos).distance <= threshold;
      });
    });
  }

  // Undo / Redo / Clear
  void _undo() {
    if (_strokes.isEmpty) return;
    setState(() {
      final last = _strokes.removeLast();
      _redoStack.add(last);
      if (_highlights.isNotEmpty) {
        _highlights.removeLast();
      }
    });
  }

  void _redo() {
    if (_redoStack.isEmpty) return;
    setState(() {
      final stroke = _redoStack.removeLast();
      _strokes.add(stroke);
    });
  }

  void _clearAll() {
    setState(() {
      _strokes.clear();
      _redoStack.clear();
      _highlights.clear();
    });
  }

  // -----------------------------
  // TextRegion 관련 헬퍼
  // -----------------------------
  Future<List<TextRegion>> _getRegionsForPage(int pageIndex) async {
    if (_pageRegionsCache.containsKey(pageIndex)) {
      return _pageRegionsCache[pageIndex]!;
    }

    final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) {
      throw Exception('캔버스 RenderBox를 찾을 수 없습니다.');
    }
    final pageSize = box.size;

    final pageText = await _pdfTextRepository.getPageText(pageIndex);

    final regions = _pageTextLayoutService.buildRegions(
      pageText: pageText,
      pageSize: pageSize,
    );

    _pageRegionsCache[pageIndex] = regions;
    return regions;
  }

  String _extractTextForHighlight({
    required Rect highlightRectNormalized,
    required List<TextRegion> regions,
  }) {
    final buffer = StringBuffer();

    for (final region in regions) {
      if (highlightRectNormalized.overlaps(region.rectNormalized)) {
        buffer.writeln(region.text.trim());
      }
    }

    return buffer.toString().trim();
  }

  /// 특정 색상의 하이라이트 텍스트를 전 페이지에서 모아서 하나의 문자열로 합치기
  Future<String> _collectHighlightTextByColor(Color targetColor) async {
    if (_highlights.isEmpty) {
      return '';
    }

    final filtered =
        _highlights.where((h) => h.color.value == targetColor.value).toList();

    if (filtered.isEmpty) {
      return '';
    }

    final buffer = StringBuffer();

    final byPage = <int, List<HighlightRegion>>{};
    for (final h in filtered) {
      byPage.putIfAbsent(h.page, () => []).add(h);
    }

    for (final entry in byPage.entries) {
      final pageIndex = entry.key;
      final pageHighlights = entry.value;

      final regions = await _getRegionsForPage(pageIndex);

      buffer.writeln('===== Page ${pageIndex + 1} =====');

      for (final h in pageHighlights) {
        final text = _extractTextForHighlight(
          highlightRectNormalized: h.rectNormalized,
          regions: regions,
        );

        if (text.isNotEmpty) {
          buffer.writeln(text);
          buffer.writeln();
        }
      }

      buffer.writeln();
    }

    return buffer.toString().trim();
  }
 // OpenAI API 호출 (요약 생성)
  // -----------------------------
  Future<String> _requestSummaryFromOpenAI(String highlightText) async {
    // 1) 프롬프트 만들기
    final prompt = _buildOpenAIPrompt(highlightText);

    // 2) OpenAI API 엔드포인트
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    // ⚠️ 실제 키 넣을 때는 테스트용으로만, 나중에는 서버로 빼는 게 안전
    const apiKey ='my_key';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final body = jsonEncode({
      'model': 'gpt-4o-mini', // 쓰고 싶은 모델명
      'messages': [
        {
          'role': 'system',
          'content':
              'You are a helpful AI tutor that writes concise Korean study notes for university students.'
        },
        {
          'role': 'user',
          'content': prompt,
        },
      ],
      'temperature': 0.3,
    });

    final response =
        await http.post(url, headers: headers, body: body).timeout(
              const Duration(seconds: 30),
            );

    if (response.statusCode != 200) {
      throw Exception('OpenAI 요청 실패: ${response.statusCode} ${response.body}');
    }

    final data = jsonDecode(response.body);
    final content = data['choices'][0]['message']['content'] as String?;
    if (content == null || content.trim().isEmpty) {
      throw Exception('OpenAI 응답에 content가 없습니다.');
    }

    return content.trim();
  }
  // -----------------------------
  // OpenAI 프롬프트 생성
  // -----------------------------
  String _buildOpenAIPrompt(String highlightText) {
    return '''
You are a helpful study assistant. Summarize and organize the following highlighted textbook content into Korean study notes.

[하이라이트 원문]
$highlightText

요청:

1. 핵심 개념을 항목별로 정리해 주세요.
2. 시험에 나올만한 포인트는 별표(*)를 붙여 강조해 주세요.
3. 필요한 경우 간단한 예시를 덧붙여 주세요.
4. 전체 분량은 A4 한 페이지를 넘지 않게 요약해 주세요.
''';
  }

  // -----------------------------
  // 상단 툴바
  // -----------------------------
  Widget _buildToolButton({
    required IconData icon,
    required DrawTool tool,
  }) {
    final isSelected = _tool == tool;
    return IconButton(
      tooltip: tool == DrawTool.pen
          ? '펜'
          : tool == DrawTool.highlighter
              ? '형광펜'
              : '지우개',
      icon: Icon(
        icon,
        color: isSelected ? Colors.blueAccent : Colors.black54,
      ),
      onPressed: () {
        setState(() {
          _tool = tool;
        });
      },
    );
  }

  Widget _buildColorDot(Color color) {
    final selected =
        _currentColor.value == color.value && _tool == DrawTool.highlighter;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentColor = color;
          if (_tool == DrawTool.eraser) {
            _tool = DrawTool.highlighter;
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: selected ? 26 : 22,
        height: selected ? 26 : 22,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? Colors.black87 : Colors.black26,
            width: selected ? 2 : 1,
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildTopToolbar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(72),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: '줌 (추후 구현 예정)',
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('줌 기능은 나중에 구현할 예정입니다.'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                _buildToolButton(icon: Icons.edit, tool: DrawTool.pen),
                _buildToolButton(
                    icon: Icons.border_color, tool: DrawTool.highlighter),
                _buildToolButton(
                    icon: Icons.auto_fix_normal, tool: DrawTool.eraser),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: '선택 도구 (추후 구현 예정)',
                  icon: const Icon(Icons.all_inclusive),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('선택 도구는 나중에 구현할 예정입니다.'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                IconButton(
                  tooltip: '도형 (추후 구현 예정)',
                  icon: const Icon(Icons.crop_square),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('도형 기능은 나중에 구현할 예정입니다.'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                const Spacer(),
                IconButton(
                  tooltip: '되돌리기',
                  icon: const Icon(Icons.undo),
                  onPressed: _undo,
                ),
                IconButton(
                  tooltip: '다시 실행',
                  icon: const Icon(Icons.redo),
                  onPressed: _redo,
                ),
                IconButton(
                  tooltip: '전체 지우기',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: _clearAll,
                ),
              ],
            ),
            Row(
              children: [
                _buildColorDot(Colors.yellowAccent),
                _buildColorDot(Colors.lightBlueAccent),
                _buildColorDot(Colors.pinkAccent),
                _buildColorDot(Colors.greenAccent),
                _buildColorDot(Colors.orangeAccent),
                const SizedBox(width: 12),
                const Text(
                  '두께',
                  style: TextStyle(fontSize: 12),
                ),
                Expanded(
                  child: Slider(
                    value: _currentWidth,
                    min: 4,
                    max: 28,
                    divisions: 12,
                    onChanged: (value) {
                      setState(() {
                        _currentWidth = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------
  // 오른쪽 AI 패널 UI
  // -----------------------------
  Widget _buildRightAiPanel() {
    final currentPageHighlights =
        _highlights.where((h) => h.page == _currentPage).toList();
    return Container(
      width: 320,
      decoration: const BoxDecoration(
        color: Color(0xFFF7F8FA),
        border: Border(
          left: BorderSide(color: Color(0xFFDDDDDD)),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 12, bottom: 8, left: 16, right: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI 학습 패널',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: _currentColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black26),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '현재 태그: $_currentTagLabel',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '현재 페이지: ${_currentPage + 1} / $_totalPages, '
                  '하이라이트 ${currentPageHighlights.length}개',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: ListView(
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    '하이라이트 좌표 (디버그 용)',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (currentPageHighlights.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFFDDDDDD)),
                      ),
                      child: const Text(
                        '이 페이지에서 형광펜으로 문장을 긋고 나면, '
                        '정규화된 좌표 정보가 여기에 표시됩니다.',
                        style: TextStyle(fontSize: 12, height: 1.4),
                      ),
                    )
                  else
                    ...currentPageHighlights.map((h) {
                      final r = h.rectNormalized;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                        child: Text(
                          'page=${h.page}, '
                          'left=${r.left.toStringAsFixed(3)}, '
                          'top=${r.top.toStringAsFixed(3)}, '
                          'right=${r.right.toStringAsFixed(3)}, '
                          'bottom=${r.bottom.toStringAsFixed(3)}',
                          style: const TextStyle(
                            fontSize: 11,
                            height: 1.3,
                          ),
                        ),
                      );
                    }),
                  const SizedBox(height: 16),
                  const Text(
                    'AI 작업 히스토리 (향후)',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildHistoryPlaceholder(
                    title: '복습 요약',
                    description: '노랑 태그로 긋는 구간이 여기에 쌓일 예정입니다.',
                  ),
                  const SizedBox(height: 8),
                  _buildHistoryPlaceholder(
                    title: '심화 설명',
                    description: '하늘 태그로 긋는 구간의 심화 설명이 저장됩니다.',
                  ),
                  const SizedBox(height: 8),
                  _buildHistoryPlaceholder(
                    title: '예제/문제',
                    description: '예제 태그를 기반으로 자동 문제가 생성됩니다.',
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFDDDDDD)),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.code, size: 18),
                    label: const Text(
                      '하이라이트 JSON 로그',
                      style: TextStyle(fontSize: 13),
                    ),
                    onPressed: () {
                      for (final h in _highlights) {
                        debugPrint(h.toString());
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('디버그 콘솔에서 하이라이트 정보를 확인할 수 있습니다.'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.highlight, size: 18),
                    label: const Text(
                      '노랑 하이라이트 텍스트 보기',
                      style: TextStyle(fontSize: 13),
                    ),
                    onPressed: () async {
                      try {
                        final result = await _collectHighlightTextByColor(
                          Colors.yellowAccent,
                        );

                        if (!mounted) return;

                        if (result.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('노랑 하이라이트에 매핑된 텍스트가 없습니다.'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                          return;
                        }

                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('노랑 하이라이트 텍스트'),
                              content: SizedBox(
                                width: double.maxFinite,
                                child: SingleChildScrollView(
                                  child: Text(
                                    result,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(),
                                  child: const Text('닫기'),
                                ),
                              ],
                            );
                          },
                        );
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('텍스트 추출 중 오류가 발생했습니다: $e'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.send, size: 18),
                    label: const Text(
                      'OpenAI 프롬프트 형식으로 보기',
                      style: TextStyle(fontSize: 13),
                    ),
                    onPressed: () async {
                      try {
                        final highlightText =
                            await _collectHighlightTextByColor(
                          Colors.yellowAccent,
                        );

                        if (!mounted) return;

                        if (highlightText.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('노랑 하이라이트에 매핑된 텍스트가 없습니다.'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                          return;
                        }

                        final prompt = _buildOpenAIPrompt(highlightText);

                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                  '노랑 하이라이트 텍스트 / OpenAI 프롬프트'),
                              content: SizedBox(
                                width: double.maxFinite,
                                child: SingleChildScrollView(
                                  child: Text(
                                    prompt,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(),
                                  child: const Text('닫기'),
                                ),
                              ],
                            );
                          },
                        );
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('프롬프트 생성 중 오류가 발생했습니다: $e'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                ),

                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.smart_toy, size: 18),
                    label: const Text(
                      'OpenAI로 요약 생성',
                      style: TextStyle(fontSize: 13),
                    ),
                    onPressed: () async {
                      try {
                        // 1) 노랑 하이라이트 텍스트 모으기
                        final highlightText =
                            await _collectHighlightTextByColor(
                          Colors.yellowAccent,
                        );

                        if (!mounted) return;

                        if (highlightText.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('노랑 하이라이트에 매핑된 텍스트가 없습니다.'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                          return;
                        }

                        // 2) 로딩 안내
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('OpenAI에 요약을 요청 중입니다...'),
                            duration: Duration(seconds: 2),
                          ),
                        );

                        // 3) OpenAI에 요약 요청
                        final summary =
                            await _requestSummaryFromOpenAI(highlightText);

                        if (!mounted) return;

                        // 4) 요약 결과 Dialog로 표시
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('AI 요약 노트'),
                              content: SizedBox(
                                width: double.maxFinite,
                                child: SingleChildScrollView(
                                  child: Text(
                                    summary,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(),
                                  child: const Text('닫기'),
                                ),
                              ],
                            );
                          },
                        );
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('OpenAI 요약 중 오류가 발생했습니다: $e'),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 6),

                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    child: const Text(
                      '전체 복습 콘텐츠 보기 (향후)',
                      style: TextStyle(fontSize: 12),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('복습 콘텐츠 화면은 추후 구현 예정입니다.'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryPlaceholder({
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------
  // 화면 전체 빌드
  // -----------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Highlight PDF'),
        centerTitle: true,
        bottom: _buildTopToolbar(),
      ),
      body: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: PDFView(
                    filePath: widget.path,
                    enableSwipe: true,
                    swipeHorizontal: true,
                    autoSpacing: true,
                    pageFling: true,
                    onRender: (pages) {
                      setState(() {
                        _totalPages = pages ?? 0;
                      });
                    },
                    onPageChanged: (page, total) {
                      setState(() {
                        _currentPage = page ?? 0;
                      });
                    },
                  ),
                ),
                Positioned.fill(
                  child: RepaintBoundary(
                    key: _canvasKey,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onPanStart: _onPanStart,
                      onPanUpdate: _onPanUpdate,
                      onPanEnd: _onPanEnd,
                      child: CustomPaint(
                        painter: DrawingPainter(_strokes),
                        size: Size.infinite,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildRightAiPanel(),
        ],
      ),
    );
  }
}

