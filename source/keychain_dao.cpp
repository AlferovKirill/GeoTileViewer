#include "keychain_dao.hpp"

auto KeychainDAO::readTokenFromKeychain(const QString& service, const QString& key, QString* error_out) -> QString {
    QEventLoop loop;
    QKeychain::ReadPasswordJob job(service);

    job.setAutoDelete(false);
    job.setKey(key);

    QObject::connect(&job, &QKeychain::Job::finished, &loop, &QEventLoop::quit);

    job.start();
    loop.exec();

    if (job.error() != 0U) {
        if (error_out != nullptr) {
            *error_out = job.errorString();
        }

        return {};
    }

    return job.textData();
}

auto KeychainDAO::writeTokenToKeychain(const QString& service, const QString& key, const QString& token, QString* error_out) -> bool {
    QEventLoop loop;
    QKeychain::WritePasswordJob job(service);

    job.setAutoDelete(false);
    job.setKey(key);
    job.setTextData(token);

    QObject::connect(&job, &QKeychain::Job::finished, &loop, &QEventLoop::quit);

    job.start();
    loop.exec();

    if (job.error() != 0U) {
        if (error_out != nullptr) {
            *error_out = job.errorString();
        }

        return false;
    }

    return true;
}
