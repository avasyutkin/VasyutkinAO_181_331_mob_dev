#include "modelfromyandexdisk.h"
#include <QDebug>
#include <iostream>

FileObject::FileObject(int size_1, QString name_1, QString created_1, QString preview_1)
    :size(size_1), name(name_1), created(created_1), preview(preview_1)
{

}

FileObject::FileObject()
{

}

ModelfromYandexDisk::ModelfromYandexDisk(QObject *parent) : QAbstractListModel(parent)
{

}

void ModelfromYandexDisk::addItem(const FileObject &newItem)
{
    //часть сигнальной системы уведомления QML об изменениях модели. Передает в QML на какую позицию и сколько элементов появляется
    beginInsertRows(QModelIndex(), rowCount(), rowCount());  //нальный номер строки вставки и конечный номер строки вставки
    objectlist << newItem;  //вставка нового элемента
    endInsertRows();  //сообщает ListView о том, что изменение модели закончено
}

int ModelfromYandexDisk::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return objectlist.count();
}

QVariant ModelfromYandexDisk::data(const QModelIndex &index, int role) const
{
    // метод для извлечения объекта и его определнного поля, заданных индексом списком и спецификатором role

    if (index.row() < 0 || (index.row() >= objectlist.count()))  // проверка на то что элемент списка не ниже нуля или не выше максимального элемента
        return QVariant();

    // получение ссылки на объект с нужным индексом
    const FileObject & itemToReturn = objectlist[index.row()];

    // получение значения нужного поля выбранного объекта
    if (role == size)
        return itemToReturn.get_size();  // при любом return этой функции значение преобразуется в QVariant
    else if (role == name)
        return itemToReturn.get_name();
    else if (role == created)
        return itemToReturn.get_created();
    else if (role == preview)
        return itemToReturn.get_preview();

    return QVariant();
}

QVariantMap ModelfromYandexDisk::get(int idx) const
{
    // метод формирует выгрузку всех полей элемента списка под номером idx

    QVariantMap map;
    if (idx >= objectlist.count()) // проверка на то что элемент списка не ниже нуля или не выше максимального элемента
        return map;
    foreach (int i, roleNames().keys())
        map[roleNames().value(i)] = data(index(idx, 0), i);

    return map;
}

void ModelfromYandexDisk::clear()
{
    beginRemoveRows(QModelIndex(), 0, rowCount()-1);  // аналогично addItem()
    objectlist.clear();  // удаление элемментов списка
    endRemoveRows();  // аналогично addItem()
}

QHash<int, QByteArray> ModelfromYandexDisk::roleNames() const
{
    // отвечает за заполнение словаря "строковое_имя" : роль
    QHash <int, QByteArray> roles;

    roles[size] = "size";  // в таком виде будет вызываться строка в QML
    roles[name] = "name";
    roles[created] = "created";
    roles[preview] = "preview";

    return roles;
}

int FileObject::get_size() const
{
    return size;
}

QString FileObject::get_name() const
{
    return name;
}

QString FileObject::get_created() const
{
    return created;
}

QString FileObject::get_preview() const
{
    return preview;
}
