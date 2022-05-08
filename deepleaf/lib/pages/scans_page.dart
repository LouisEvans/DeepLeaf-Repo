import 'package:deepleaf/state/home_page_state.dart';
import 'package:deepleaf/widgets/base_widget.dart';
import 'package:deepleaf/widgets/prediction_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Page displaying previous scans
class ScansPage extends StatelessWidget {
  const ScansPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: BaseWidget<HomePageState>(
            state: Provider.of<HomePageState>(context),
            onStateReady: (state) {
              state.getRecentPredictions();
            },
            builder: (context, state, child) {
              return ListView.builder(
                itemCount: state.recentPredictions.length + 1,
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 20),
                      child: Center(
                        child: Column(children: [
                          Text(
                            "Previous scans",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w700),
                          ),
                          GestureDetector(
                            onTap: () {
                              state.clearBox();
                            },
                            child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 16),
                                child: Text(
                                  "Clear",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          )
                        ]),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: PredictionPreview(
                            prediction: state.recentPredictions[
                                state.recentPredictions.length - i]),
                      ),
                      Divider()
                    ],
                  );
                },
              );
            }));
  }
}
