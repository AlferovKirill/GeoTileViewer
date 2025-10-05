#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QString>
#include <QSurfaceFormat>
#include <QStandardPaths>
#include <QDir>

#include "config/project_description.h"
#include "coordinates_converter.hpp"
#include "keychain_dao.hpp"
#include "translation_controller.hpp"

auto main(int argc, char* argv[]) -> int {
    QGuiApplication::setHighDpiScaleFactorRoundingPolicy(Qt::HighDpiScaleFactorRoundingPolicy::PassThrough);

    QGuiApplication app(argc, argv);

    const QString service = project_name;
    const QString key_name = "maps.access_token";
    QString keychain_err;

    const QProcessEnvironment env = QProcessEnvironment::systemEnvironment();

    QString saved_token = KeychainDAO::readTokenFromKeychain(service, key_name, &keychain_err);
    QString env_token = env.value(QStringLiteral("MAPS_ACCESS_TOKEN"));
    QString token;

    if (!env_token.isEmpty() && env_token != saved_token) {
        token = env_token;
        QString write_err;

        if (!KeychainDAO::writeTokenToKeychain(service, key_name, token, &write_err)) {
            qWarning() << "Keychain write error:" << write_err;
        }
    } else if (!saved_token.isEmpty()) {
        token = saved_token;
    } else {
        qWarning() << "No token in keychain; set MAPS_ACCESS_TOKEN env var for first run";
    }

    QGuiApplication::setApplicationName(project_name);
    QGuiApplication::setApplicationVersion(project_version);
    QGuiApplication::setOrganizationDomain(project_homepage_url);
    QGuiApplication::setOrganizationName(author);

    QString maps_cache_path = QStandardPaths::writableLocation(QStandardPaths::GenericCacheLocation) + "/" + project_name + "_cache";
    QDir dir;

    if (!dir.exists(maps_cache_path)) {
        dir.mkpath(maps_cache_path);
    }

    TranslationController translation_controller;

    qmlRegisterSingletonType<CoordinatesConverter>("ui", 1, 0, "CoordinatesConverter", [](QQmlEngine*, QJSEngine*) -> CoordinatesConverter* {
        return new CoordinatesConverter();  // NOLINT(cppcoreguidelines-owning-memory)
    });

    QQmlApplicationEngine engine;

    translation_controller.setEngine(&engine);

    engine.rootContext()->setContextProperty("translation_controller", &translation_controller);
    engine.rootContext()->setContextProperty(QStringLiteral("maps_access_token"), token);
    engine.rootContext()->setContextProperty(QStringLiteral("maps_cache_path"), maps_cache_path);

    const QUrl url(QStringLiteral("qrc:/app/qml/ui/Main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app, [url](QObject* obj, const QUrl& obj_url) {
        if (obj == nullptr && url == obj_url) {
            QCoreApplication::exit(-1);
        }
    }, Qt::QueuedConnection);

    engine.load(url);

    translation_controller.initializeSystemLocale();

    return QGuiApplication::exec();
}
