part of 'screen.dart';

class _MyCompanyDetail extends StatelessWidget {
  const _MyCompanyDetail({required this.model});
  final MyCompanyModel model;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColorHelper.black.withOpacity(0.10),
        appBar: AppBar(
          title: Text(model.companyName ?? 'Null'),
          foregroundColor: MyColorHelper.white.withOpacity(0.75),
          backgroundColor: MyColorHelper.black1,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
                decoration: const BoxDecoration(
                    color: MyColorHelper.black1,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text(
                        model.description ?? 'Null',
                        maxLines: 4,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: MyColorHelper.white.withOpacity(0.75),
                        ),
                      ),
                    ),
                    SizedBox(width: 4.0),
                    Expanded(
                      flex: 2,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: MyColorHelper.red1.withOpacity(0.08),
                            ),
                            color: MyColorHelper.red1.withOpacity(0.05),
                            image: model.logoUrl != null
                                ? DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(model.logoUrl!),
                                  )
                                : const DecorationImage(
                                    image: AssetImage(
                                    'assets/images/default-company-logo.png',
                                  )),
                          ),
                        ),
                      ),
                    )
                    // Expanded(
                    //   flex: 2,
                    //   child: model.logoUrl != null
                    //       ? Image.network(model.logoUrl!)
                    //       : Image.asset('assets/images/default-company-logo.png'),
                    // )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, top: 24.0, right: 16.0),
                child: Column(
                  children: [
                    _detail('Owner\'s Name', model.ownerName),
                    // _detail('Mailing Address', model.mailingAddress),
                    // _detail('Phone', model.phone),
                    _detail('Email', model.email),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _detail(String str1, String? str2) => Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Expanded(
                child: Text('$str1: ',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ))),
            Text(
              str2 ?? 'Null',
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
}
