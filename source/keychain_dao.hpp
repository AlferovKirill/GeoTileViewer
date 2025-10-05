#pragma once

#include <QCoreApplication>
#include <QDebug>
#include <QProcessEnvironment>

#include <qt6keychain/keychain.h>

struct KeychainDAO {
    static auto readTokenFromKeychain(const QString& service, const QString& key, QString* error_out) -> QString;
    static auto writeTokenToKeychain(const QString& service, const QString& key, const QString& token, QString* error_out) -> bool;
};
