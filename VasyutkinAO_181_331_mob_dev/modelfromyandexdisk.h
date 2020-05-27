#ifndef MODELFROMYANDEXDISK_H
#define MODELFROMYANDEXDISK_H

#include <QObject>
#include <QAbstractListModel>

class FileObject
{
public:
    FileObject();
    FileObject(QString size_1, QString name_1, QString created_1, QString preview_1);

    QString get_size() const;
    QString get_name() const;
    QString get_created() const;
    QString get_preview() const;

private:
    QString size;
    QString name;
    QString created;
    QString preview;
};

class ModelfromYandexDisk : public QAbstractListModel
        // Класс QAbstractItemModel обеспечивает:
        // 1. Помимо хранения элементов модели в QList
        // 2. Трансляцию строковых запросов QML в адреса (свойств и методов) С++
        // 3. Интерактивность и обновление QML-связанных ...View посредством специальной сигнальной системы
{
    Q_OBJECT
public:
    enum enumRoles {  // должно быть столько идентификаторов, сколько свойств в модели объекта
        size = Qt::UserRole + 1, name, created, preview  // 256 зарезервировано для UserRole, начинаем с 257
    };

    explicit ModelfromYandexDisk(QObject *parent = nullptr);

    void addItem(const FileObject & newItem);
    int rowCount(const QModelIndex & parent = QModelIndex()) const;  // необходим, чтобы ...View заранее подготавливались к отрисовке (чтобы получать количество элементов списка)
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const ;  // необходим для получения данных элемента index, соответствующих заданному с помощью role свойству элементу
    QVariantMap get(int idx) const;  // необходим для выгрузки i-го элемента целиком вместе со всеми свойствами
    void clear();  // очистка

private:
    QList<FileObject> objectlist;

protected:
    QHash<int, QByteArray> roleNames() const;

};

#endif // MODELFROMYANDEXDISK_H
