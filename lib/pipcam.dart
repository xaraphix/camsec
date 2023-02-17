
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:flutter_vlc_player/src/vlc_player_controller.dart';

final aspectRatios = [
    [1, 1],
    [2, 3],
    [3, 2],
    [16, 9],
    [9, 16]
];

void main() {
    runApp(PipCam());
}

class PipCam extends StatefulWidget {
    const PipCam({Key? key}): super(key: key);

    @override
    State<PipCam> createState() => _PipCamState();
}

class _PipCamState extends State<PipCam> {
    
    late Floating floating;
    List<int> aspectRatio = aspectRatios[3];
    bool isPipAvailable = false;
    
      VlcPlayerController _vlcViewController = new VlcPlayerController.network(
    "rtmp:///live/MainGate_L",
    autoPlay: true,
  );


    @override
    void initState() {
        super.initState();
        floating = Floating();
        floating.enable(Rational(aspectRatio[0], aspectRatio[1]));
        requestPipAvailable();
    }

    void requestPipAvailable() async {
        isPipAvailable = await floating.isPipAvailable;
        setState((){});
    }
    
        @override
    void dispose(){
        super.dispose();
        floating.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return PiPSwitcher(
            childWhenEnabled:              new VlcPlayer(
              controller: _vlcViewController,
              aspectRatio: 16 / 9,
              placeholder: Text("Hello World"),
            ),
            childWhenDisabled:   Scaffold(
                appBar: AppBar(title: const Text("Flutter pip view")),
                body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        const SizedBox(width: double.infinity),
                        Text('Pip is ${isPipAvailable ? '': 'not '}available'),
                    DropdownButton<List<int>>(
                            value: aspectRatio,
                            items: aspectRatios.map<DropdownMenuItem<List<int>>>(
                                (List<int> value) => DropdownMenuItem<List<int>>(
                                    value: value,
                                    child: Text('${value.first}: ${value.last}')
                                )

                            ).toList(),
                            onChanged: (List<int>? newValue) {
                                if (newValue == null) return;
                                aspectRatio = newValue;
                                setState(() {});
                            },
                        ),
                        IconButton(onPressed: isPipAvailable? 
                        () => floating.enable(Rational(aspectRatio[0], aspectRatio[1])) : null, icon: const Icon(Icons.picture_in_picture))
                    ],

                )
            )
            );
    }
}

