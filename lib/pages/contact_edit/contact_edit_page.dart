import 'package:contact_api/contact_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/widgets.dart';
import 'bloc/contact_edit_bloc.dart';

class ContactEditPage extends StatelessWidget {
  final Contact? contact;
  const ContactEditPage({super.key, this.contact});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactEditBloc(
        contactApi: context.read(),
        initialValue: contact,
      ),
      child: const _ContactEditView(),
    );
  }
}

class _ContactEditView extends StatelessWidget {
  const _ContactEditView();

  void _onSaving(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Container(
            alignment: Alignment.center,
            width: 60.0,
            height: 60.0,
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  void _onSuccess(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop(); // Closes Loading Dialog

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contato salvo com sucesso!')),
    );

    Navigator.pop(context); // Closes the page
  }

  void _onFailure(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop(); // Closes Loading Dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Erro ao salvar o contato')),
    );
  }

  void _onStatusChanged(BuildContext context, ContactEditState state) {
    switch (state.status) {
      case ContactEditStatus.saving:
        _onSaving(context);
        break;
      case ContactEditStatus.success:
        _onSuccess(context);
        break;
      case ContactEditStatus.failure:
        _onFailure(context);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ContactEditBloc>();

    final title = controller.isCreating ? 'Novo Contato' : 'Editar Contato';

    return BlocListener<ContactEditBloc, ContactEditState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: _onStatusChanged,
      child: Form(
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            centerTitle: true,
            actions: const [_SaveButton()],
            elevation: 0.0,
          ),
          body: ListView(
            children: const [
              _ContactHeader(),
              _ContactEditForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactHeader extends StatelessWidget {
  const _ContactHeader();

  Future<ImageSource?> _selectImageSource(BuildContext context) async {
    const bottomSheetShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    );

    return await showModalBottomSheet<ImageSource>(
      context: context,
      shape: bottomSheetShape,
      builder: (context) {
        return BottomSheet(
          shape: bottomSheetShape,
          enableDrag: false,
          onClosing: () {},
          builder: (context) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Selecione o local da imagem',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54)
                  ),
                  SizedBox(height: 8.0),
                  Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                      ImageSourceItem(
                        icon: Icons.camera_alt,
                        label: 'Câmera',
                        value: ImageSource.camera,
                      ),
                      ImageSourceItem(
                        icon: Icons.image_rounded,
                        label: 'Galeria',
                        value: ImageSource.gallery,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final controller = context.read<ContactEditBloc>();
    final colors = Theme.of(context).colorScheme;

    final imageSource = await _selectImageSource(context);

    if (imageSource == null) return;

    final image = await ImagePicker().pickImage(source: imageSource);

    if (image == null) return;

    await _cropImage(controller, colors, image);
  }

  Future<void> _cropImage(
    ContactEditBloc controller,
    ColorScheme colors,
    XFile image,
  ) async {
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      cropStyle: CropStyle.rectangle,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Recortar Foto',
          toolbarColor: colors.primary,
          showCropGrid: true,
          lockAspectRatio: true,
          initAspectRatio: CropAspectRatioPreset.square,
          toolbarWidgetColor: colors.onPrimary,
          activeControlsWidgetColor: colors.primary,
        ),
        IOSUiSettings(
          title: 'Recortar Foto',
        ),
      ],
    );

    if (croppedImage != null) {
      controller.setPhotoUrl(croppedImage.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ContactEditHeaderCustomPainter(
        color: Theme.of(context).primaryColor,
      ),
      child: GestureDetector(
        onTap: () => _pickImage(context),
        child: Container(
          height: 200.0,
          alignment: Alignment.bottomCenter,
          child: BlocBuilder<ContactEditBloc, ContactEditState>(
            buildWhen: (previous, current) =>
                previous.photoUrl != current.photoUrl,
            builder: (context, state) {
              return ContactPhoto(photoUrl: state.photoUrl, radius: 70.0);
            },
          ),
        ),
      ),
    );
  }
}

class _ContactEditHeaderCustomPainter extends CustomPainter {
  final Color color;

  _ContactEditHeaderCustomPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    final Size(:height, :width) = size;

    path.moveTo(width, 0.0);
    path.lineTo(0.0, 0.0);
    path.lineTo(0.0, height - 50.0);
    path.quadraticBezierTo(
        width * 0.25, height - 30, width * 0.75, height - 40);
    path.lineTo(width, height - 50.0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (Form.of(context).validate()) {
          FocusScope.of(context)
              .unfocus(); // removes textfield focus, hiding the keyboard
          context.read<ContactEditBloc>().save();
        }
      },
      icon: const Icon(Icons.check),
    );
  }
}

class _ContactEditForm extends StatelessWidget {
  const _ContactEditForm();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ContactEditBloc>();
    const divider = SizedBox(height: 16.0);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            initialValue: controller.state.name,
            onChanged: (value) => controller.setName(value),
            keyboardType: TextInputType.name,
            inputFormatters: [LengthLimitingTextInputFormatter(32)],
            decoration: const InputDecoration(
              labelText: 'Nome',
            ),
          ),
          divider,
          TextFormField(
            initialValue: controller.state.email,
            onChanged: (value) => controller.setEmail(value),
            keyboardType: TextInputType.emailAddress,
            inputFormatters: [LengthLimitingTextInputFormatter(64)],
            decoration: const InputDecoration(
              labelText: 'E-mail',
            ),
          ),
          divider,
          TextFormField(
            initialValue: controller.state.phone,
            onChanged: (value) => controller.setPhone(value),
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(
              labelText: 'Telefone',
            ),
          ),
          divider,
          TextFormField(
            initialValue: controller.state.note,
            onChanged: (value) => controller.setNote(value),
            keyboardType: TextInputType.multiline,
            inputFormatters: [LengthLimitingTextInputFormatter(255)],
            maxLength: 255,
            minLines: 3,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Observação',
            ),
          ),
        ],
      ),
    );
  }
}
