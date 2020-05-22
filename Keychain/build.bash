#############################################################
#  build.bash
#############################################################
#!/bin/bash
# Выход из скрипта, если какая-то команда завершится неудачно
set -e
PROJECT_NAME=Keychain
# Название Bundle
BUNDLE_DIR=${PROJECT_NAME}.app
# Название папки временных файлов
TEMP_DIR=_BuildTemp

echo → 📱 Сборка ${PROJECT_NAME} под симулятор устройства 
#####################################
echo → Шаг 1: Подготовка рабочих папок
#####################################
# Удаление прошлых папок перед новым Build
rm -rf ${BUNDLE_DIR}
rm -rf ${TEMP_DIR}
mkdir ${BUNDLE_DIR}
echo → ✅ Папка ${BUNDLE_DIR} была создана
mkdir ${TEMP_DIR}
echo → ✅ Папка ${TEMP_DIR} была создана

# Корневая директория проекта
SOURCE_DIR=Keychain

# Все *.swift файлы в директории проекта
SWIFT_SOURCE_FILES=${SOURCE_DIR}/*.swift

#####################################
echo → Шаг 2: Компиляций Pod файлов
#####################################
MODULE_NAME=SwiftKeychainWrapper
SOURCE_POD_DIR=./Pods/SwiftKeychainWrapper/SwiftKeychainWrapper
SOURCE_POD_FILES=${SOURCE_POD_DIR}/*.swift

SDK_PATH=$(xcrun --show-sdk-path --sdk iphonesimulator)
TARGET=x86_64-apple-ios13.2-simulator

#############################################################
echo → Создание объектных файлов
#############################################################
swiftc -c ${SOURCE_POD_FILES} \
-sdk ${SDK_PATH} \
-target ${TARGET} \
-module-name ${MODULE_NAME}

#############################################################
echo → Создание модуля
#############################################################
swiftc -emit-module ${SOURCE_POD_FILES} \
-sdk ${SDK_PATH} \
-target ${TARGET} \
-module-name ${MODULE_NAME}

#############################################################
echo → Создание библиотеки
#############################################################
ar -rcs lib${MODULE_NAME}.a ./*.o
echo → ✅ Компиляция Pod файлов прошла успешно!


#####################################
echo → Шаг 3: Компиляция Swift файлов
#####################################

# Компиляция ресурсов
  swiftc -c ${SWIFT_SOURCE_FILES} \
  -sdk ${SDK_PATH} \
  -target ${TARGET} \
-lSwiftKeychainWrapper \
-L. \
-I. \
  -emit-executable \
  -o ${BUNDLE_DIR}/${PROJECT_NAME}
echo → ✅ Компиляция Swift source файла ${SWIFT_SOURCE_FILES}

#############################################################
echo → Шаг 4: Компиляция Storyboards
#############################################################
# Все сториборды, что лежат в папке Storyboards
STORYBOARDS=${SOURCE_DIR}/Base.lproj/*.storyboard
# Путь к папке с компилированными Storyboards
STORYBOARD_OUT_DIR=${BUNDLE_DIR}/Base.lproj
mkdir -p ${STORYBOARD_OUT_DIR}
echo → ✅ Папка ${STORYBOARD_OUT_DIR} была создана
for storyboard_path in ${STORYBOARDS}; do
  #
  ibtool $storyboard_path \
    --compilation-directory ${STORYBOARD_OUT_DIR}
  echo → ✅ Storyboards скомпилированы $storyboard_path
done

#############################################################
echo → Актуально для запуска на физическом устройстве
#############################################################
#############################################################
echo → Шаг 5: Копирование Библиотек Swift Runtime
#############################################################

# Папка, в которой исполняемые библиотеки Swift находятся на компьютере
SWIFT_LIBS_SRC_DIR=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift-5.0/iphoneos
# Папка внутри Bundle приложения, куда мы хотим скопировать библиотеки
SWIFT_LIBS_DEST_DIR=${BUNDLE_DIR}/${FRAMEWORKS_DIR}
# Список всех библиотек, которые мы хотим скопировать
SWIFT_RUNTIME_LIBS=( libswiftCore.dylib libswiftCoreFoundation.dylib libswiftCoreGraphics.dylib libswiftDarwin.dylib libswiftDispatch.dylib libswiftFoundation.dylib libswiftObjectiveC.dylib libswiftos.dylib )
mkdir -p ${BUNDLE_DIR}/${FRAMEWORKS_DIR}
echo → ✅ Create ${SWIFT_LIBS_DEST_DIR} folder
for library_name in "${SWIFT_RUNTIME_LIBS[@]}"; do
  # Копирование библиотек
  cp ${SWIFT_LIBS_SRC_DIR}/$library_name ${SWIFT_LIBS_DEST_DIR}/
  echo → ✅ Копирование $library_name в ${SWIFT_LIBS_DEST_DIR}
done
#############################################################
#############################################################
if [ "${BUILDING_FOR_DEVICE}" != true ]; then
  # If we build for simulator, we can exit the scrip here
  echo → 🎉 Building ${PROJECT_NAME} for simulator successfully finished! 🎉
fi

#############################################################
# Копируем Info.plist
#############################################################

cp ./Info.plist ./${BUNDLE_DIR}

#############################################################
echo → 🚯 Шаг 6: Чистим за собой!
#############################################################
rm ./*.o ./*.a ./*.swiftmodule ./*.swiftdoc 

#############################################################
echo → 👨‍💻 Шаг 7: Запускаем симулятор
#############################################################

open -a "Simulator.app"
sleep 7s

#############################################################
echo → 👨‍🔧 Шаг 8: Устанавливаем приложение на симулятор
#############################################################

xcrun simctl install booted Keychain.app

#############################################################
echo → 🎮 Шаг 9: Запускаем приложение
#############################################################

xcrun simctl launch booted phenomendevelopers.Keychain
