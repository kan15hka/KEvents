import 'package:flutter/material.dart';
import 'package:kevents/common/constants.dart';
import 'package:kevents/common/utils/utils.dart';
import 'package:kevents/common/widgets/delete_row_dialog.dart';
import 'package:kevents/common/widgets/frosted_glass.dart';
import 'package:kevents/common/widgets/shimmer_arrow_right.dart';

class ParticipantTable extends StatefulWidget {
  final List<List<dynamic>> csvData;
  final List<dynamic> headerData;
  final List<List<dynamic>> cellData;
  final bool isKIDPresent;
  const ParticipantTable({
    super.key,
    required this.csvData,
    required this.headerData,
    required this.cellData,
    required this.isKIDPresent,
  });

  @override
  State<ParticipantTable> createState() => _ParticipantTableState();
}

class _ParticipantTableState extends State<ParticipantTable> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.csvData.isEmpty)
        //File isEmpty
        ? const Expanded(
            child: Center(
                child: Text(
              'File is Empty',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            )),
          )
        //Data Table
        : (!widget.isKIDPresent)
            ? const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text("K! ID does not match!\nParticipant not found",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                    )),
              )
            : Stack(
                alignment: Alignment.centerRight,
                children: [
                  Column(
                    children: [
                      Container(
                        //color: Color.fromARGB(47, 255, 255, 255),
                        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: FrostedGlass(
                          borderRadius: 10.0,
                          isBorderRequired: true,
                          blurValue: 5.0,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              border: TableBorder.symmetric(
                                  inside: BorderSide(
                                color: kWhite.withOpacity(0.25),
                              )),
                              columnSpacing: 20.0,
                              horizontalMargin: 10.0,

                              //columns: csvHeader[0]
                              columns: widget.headerData
                                  .map(
                                    (item) => DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          item.toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),

                              rows: widget.cellData
                                  .map(
                                    (csvrow) => DataRow(
                                      onLongPress: () {
                                        deleteRowDialog(
                                            context: context,
                                            kid: csvrow[1].toString(),
                                            onTapYes: () {
                                              removeParticipantDetail(
                                                kid: csvrow[1].toString(),
                                              );
                                              setState(() {});
                                              Navigator.pop(context);
                                            });
                                      },
                                      cells: csvrow
                                          .map(
                                            (csvItem) => DataCell(
                                              Center(
                                                child: Container(
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxWidth: 130.0),
                                                  //color: Colors.red,
                                                  child: Text(
                                                    csvItem.toString(),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                      if (widget.cellData.isEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Text(
                            'File is Empty',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        )
                      ]
                    ],
                  ),
                  if (widget.cellData.isNotEmpty) ...[
                    const Positioned(left: 10.0, child: ShimmerArrowRight())
                  ]
                ],
              );
  }
}
