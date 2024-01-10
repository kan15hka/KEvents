import 'package:flutter/material.dart';

class ScannedCodeCard extends StatelessWidget {
  final String name;
  final String mkid;
  const ScannedCodeCard({super.key, required this.name, required this.mkid});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.15,
        ),
        padding: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 35.0,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0))),
              child: const Center(
                  child: Text(
                "Scanned Code",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
              )),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Name: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(name),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "MKID: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        mkid,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
