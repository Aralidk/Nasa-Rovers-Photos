import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa/models/rover.dart';
import '../../../models/photo.dart';
import '../bloc/bloc_filter.dart';


class homePage extends StatefulWidget {
  final Rover rover;
  const homePage({Key? key, required this.rover}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  late FilterBloc _filterBloc;
  late Camera selectedCamera;
  late int selectedSol;


  @override
  void initState() {
    selectedCamera = widget.rover.availableCameras.first;
    selectedSol = 100;

    _filterBloc = FilterBloc(rover: widget.rover)
      ..add(AddFilter(selectedCamera, selectedSol));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.rover.name, style: TextStyle(color: Colors.orangeAccent),),
        trailing: CupertinoButton(
          child: const Text("Filtre", style: TextStyle(color: Colors.orangeAccent),),
          padding: const EdgeInsets.all(0),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                var pickerCamera = CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem:
                    widget.rover.availableCameras.indexOf(selectedCamera),
                  ),
                  itemExtent: 32.0,
                  backgroundColor: Colors.white,
                  onSelectedItemChanged: (int index) {},
                  children: widget.rover.availableCameras
                      .map((e) => Text(e.toString().split('.').last))
                      .toList(),
                );
                return Container(
                  height: 300.0,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: pickerCamera,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CupertinoButton(
                              child: const Text('İptal', style: TextStyle(color: Colors.orangeAccent),),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          CupertinoButton(
                              child: const Text('Ekle', style: TextStyle(color: Colors.orangeAccent),),
                              onPressed: () {
                                selectedCamera = widget.rover.availableCameras[
                                pickerCamera
                                    .scrollController!.selectedItem];
                                _filterBloc.add(
                                    AddFilter(selectedCamera, selectedSol));
                                Navigator.pop(context);
                              }),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      child: BlocBuilder(
        bloc: _filterBloc,
        builder: (context, state) {
          if (state is FilterResult) {
            if (state.photos.isEmpty) {
              return const Center(
                  child: Text('  Seçilen kamera için Apiden sağlanan gün için fotoğraf bulunamadı. Farklı kamera deneyiniz.    ', style: TextStyle(color: Colors.orangeAccent, fontSize: 15, decoration: TextDecoration.none),));
            }
            return Center(
              child: GridView.count(

                crossAxisCount: 2,
                childAspectRatio: 0.8,
                children: state.photos
                    .map((e) => PhotoCards(
                  photo: e,
                  key: Key(e.id.toString()),
                ))
                    .toList(),
              ),
            );
          } else if (state is FilterError) {
            return Center(child: Text(state.message, style: TextStyle(color: Colors.orangeAccent),));
          } else {
            //for loading state. There is no other states
            return const Center(child: CupertinoActivityIndicator());
          }
        },
      ),
    );
  }
}

class PhotoCards extends StatelessWidget {
  final Photo photo;
  const PhotoCards({
    Key? key,
    required this.photo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Image.network(
              photo.imageUrl,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return const Text('Resim yüklenemedi.', style: TextStyle(color: Colors.orangeAccent),);
              },
            ).image,
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          margin: const EdgeInsets.fromLTRB(15, 15, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                photo.cameraName,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
      onPressed: () {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text(' Kamera: ' + photo.cameraName + '  Tarih: ' + photo.earthDate.toString()+ '  Rover İsmi: ' +photo.roverName + '  İniş Tarihi: '+ photo.landingDate+ '  Fırlatma Tarihi: ' + photo.launchDate+ '  Görev Durumu: ' + photo.Status),
            content: Image.network(photo.imageUrl),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('Kapat', style: TextStyle(color: Colors.orangeAccent),),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}