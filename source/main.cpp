#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSurfaceFormat>
#include <QString>

#include "translation_controller.hpp"
#include "coordinates_converter.hpp"
#include "keychain_dao.hpp"

#include "config/project_description.h"


auto main(int argc, char* argv[]) -> int {
    QGuiApplication::setHighDpiScaleFactorRoundingPolicy(Qt::HighDpiScaleFactorRoundingPolicy::PassThrough);
    
    QGuiApplication app(argc, argv);

    const QString service = project_name;
    const QString key_name = "maps.access_token";
    QString keychain_err;

    QString token = KeychainDAO::readTokenFromKeychain(service, key_name, &keychain_err);

    qDebug() << "token = " << token;

    if (token.isEmpty()) {
        const QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
        token = env.value(QStringLiteral("MAPS_ACCESS_TOKEN"));

        if (!token.isEmpty()) {
            QString write_err;

            if (!KeychainDAO::writeTokenToKeychain(service, key_name, token, &write_err)) {
                qWarning() << "Keychain write error:" << write_err;
            }
        } else {
            qWarning() << "No token in keychain; set MAPS_ACCESS_TOKEN env var for first run";
        }
    }

    QGuiApplication::setApplicationName(project_name);
    QGuiApplication::setApplicationVersion(project_version);
    QGuiApplication::setOrganizationDomain(project_homepage_url);
    QGuiApplication::setOrganizationName(author);

    TranslationController translation_controller;

    qmlRegisterSingletonType<CoordinatesConverter>("ui", 1, 0, "CoordinatesConverter", 
    [](QQmlEngine*, QJSEngine*) -> CoordinatesConverter* {
        return new CoordinatesConverter(); // NOLINT(cppcoreguidelines-owning-memory)
    });

    QQmlApplicationEngine engine;

    translation_controller.setEngine(&engine);

    engine.rootContext()->setContextProperty("translation_controller", &translation_controller);
    engine.rootContext()->setContextProperty(QStringLiteral("maps_access_token"), token);

    const QUrl url(QStringLiteral("qrc:/app/qml/ui/Main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app, [url](QObject* obj, const QUrl& obj_url){
        if (obj == nullptr && url == obj_url) {
            QCoreApplication::exit(-1);
        }
    }, Qt::QueuedConnection);

    engine.load(url);

    translation_controller.initializeSystemLocale();

    return QGuiApplication::exec();
}
