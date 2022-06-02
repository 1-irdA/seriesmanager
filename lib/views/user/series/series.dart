import 'package:flutter/material.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_series.dart';
import 'package:seriesmanager/services/series_service.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/utils/redirects.dart';
import 'package:seriesmanager/utils/validator.dart';
import 'package:seriesmanager/views/error.dart';
import 'package:seriesmanager/views/user/series/series_details.dart';
import 'package:seriesmanager/widgets/drawer.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:seriesmanager/widgets/responsive_layout.dart';
import 'package:seriesmanager/widgets/series_card.dart';
import 'package:seriesmanager/widgets/textfield.dart';

class SeriesPage extends StatefulWidget {
  const SeriesPage({Key? key}) : super(key: key);

  @override
  State<SeriesPage> createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Mes séries', style: textStyle),
      ),
      drawer: const AppDrawer(),
      body: const Layout(),
    );
  }
}

class Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final _seriesService = SeriesService();
  final _title = TextEditingController();
  late String title;

  Future<List<UserSeries>> _loadSeries(String name) async {
    final HttpResponse response = name.isEmpty
        ? await _seriesService.getAll()
        : await _seriesService.getByTitle(title);

    if (response.success()) {
      return createUserSeries(response.content());
    } else {
      throw Exception();
    }
  }

  _LayoutState() {
    _title.addListener(() {
      if (_title.text.isEmpty) {
        setState(() => title = '');
      } else {
        setState(() => title = _title.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppResponsiveLayout(
          mobileLayout: _buildMobileLayout(),
          desktopLayout: _buildDesktopLayout(),
        ),
        FutureBuilder<List<UserSeries>>(
          future: _loadSeries(_title.text),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const ErrorPage();
            } else if (snapshot.hasData) {
              return snapshot.data!.isEmpty
                  ? Text(
                      'Aucune série vue',
                      style: textStyle,
                      textAlign: TextAlign.center,
                    )
                  : Expanded(
                      child: GridView.count(
                        crossAxisCount: MediaQuery.of(context).size.width < 400
                            ? 1
                            : MediaQuery.of(context).size.width < 600
                                ? 2
                                : 3,
                        children: <Widget>[
                          for (UserSeries series in snapshot.data!)
                            AppSeriesCard(
                              series: series,
                              onTap: () => push(
                                context,
                                SeriesDetailsPage(series: series),
                              ),
                            ),
                        ],
                      ),
                    );
            }
            return const AppLoading();
          },
        )
      ],
    );
  }

  Widget _buildMobileLayout() => _buildForm();

  Widget _buildDesktopLayout() => Padding(
        child: _buildMobileLayout(),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 4,
        ),
      );

  Widget _buildForm() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AppTextField(
            keyboardType: TextInputType.text,
            label: 'Nom de la série',
            textfieldController: _title,
            validator: emptyValidator,
            icon: Icons.search_outlined,
          ),
        ],
      );
}
