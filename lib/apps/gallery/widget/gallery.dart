import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa/models/rover.dart';
import '../../../models/photo.dart';
import '../bloc/bloc_filter.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';

class Gallery extends StatefulWidget {
  final Rover rover;
  const Gallery({Key? key, required this.rover}) : super(key: key);

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
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
        middle: Text(widget.rover.name),
        trailing: CupertinoButton(
          child: const Text("Filtre"),
          padding: const EdgeInsets.all(0),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                /*
                var pickerSol = CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: selectedSol,
                  ),
                  itemExtent: 32.0,
                  backgroundColor: Colors.white,
                  onSelectedItemChanged: (int index) {},
                  children: List<Widget>.generate(
                    2000,
                        (int index) {
                      return Center(
                        child: Text('$index sol'),
                      );
                    },
                  ),
                );*/

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
                              child: pickerSol,
                            ),
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
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          CupertinoButton(
                              child: const Text('Add'),
                              onPressed: () {
                                selectedCamera = widget.rover.availableCameras[
                                pickerCamera
                                    .scrollController!.selectedItem];
                                selectedSol =
                                    pickerSol.scrollController!.selectedItem;
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
                  child: Text('There are no photos for given filters'));
            }
            return Center(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                children: state.photos
                    .map((e) => ImageCard(
                  photo: e,
                  key: Key(e.id.toString()),
                ))
                    .toList(),
              ),
            );
          } else if (state is FilterError) {
            return Center(child: Text(state.message));
          } else {
            //for loading state. There is no other states
            return const Center(child: CupertinoActivityIndicator());
          }
        },
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  final Photo photo;
  const ImageCard({
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
            //Image widget supports ghost loader etc. in material. For cupertion I cant make it work
            image: Image.network(
              photo.imageUrl,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return const Text('😢 Failed to load image');
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
              Text(
                photo.sol.toString() + ' Sol',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
      onPressed: () {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text(photo.cameraName + ' ' + photo.earthDate.toString()),
            content: Image.network(photo.imageUrl),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('Close'),
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