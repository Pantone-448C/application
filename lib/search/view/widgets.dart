import 'package:application/search/cubit/search_cubit.dart';
import 'package:application/search/cubit/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  static const _zoom = 14.47;
  GoogleMapController? _controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  static final CameraPosition _brisbane = CameraPosition(
    target: LatLng(-27.5125, 152.9812),
    zoom: _zoom,
  );


  @override
  void dispose() {
    super.dispose();
  }

  _moveCamera(LatLng newPosition) {
    final p = CameraPosition(target: LatLng(
        newPosition.latitude,
        newPosition.longitude),
        zoom: _zoom);
    _controller?.moveCamera(CameraUpdate.newCameraPosition(p));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchCubit, SearchState> (
        listener: (context, state) {
          if (state is GotUserPosition) {
            _moveCamera(LatLng(state.userPosition.latitude,
                state.userPosition.longitude));
          }

          if (state is SearchResults) {
            var markerIdCounter = 1;
            var getMarkerId = (int i) {
              return 'marker_id_$i';
            };
            // add markers
            final newMarkers = Map<MarkerId, Marker>();
            if (state.results.isNotEmpty) {
              final l = state.results[0].location;
              _moveCamera(LatLng(l.latitude, l.longitude));
            }
            state.results.forEach((element) {


              final markerIdVal = getMarkerId(markerIdCounter++);
              final MarkerId markerId = MarkerId(markerIdVal);

              newMarkers[markerId] = Marker(
                markerId: markerId,
                position: element.location,
                icon: BitmapDescriptor.defaultMarker,
                alpha: 1.0,
                visible: true,
                onTap: () => context.read<SearchCubit>().selectActivity(element)
              );
            });
            setState(() {
              print(markers);
              markers = newMarkers;
            });
          }

        },
        builder: (BuildContext context, state) {
          return GoogleMap(
            mapType: MapType.terrain,
            initialCameraPosition: _brisbane,
            //liteModeEnabled: true,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            markers: Set<Marker>.of(markers.values),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
          );
        });
  }
}
