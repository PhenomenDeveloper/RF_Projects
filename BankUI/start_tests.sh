echo → Шаг 1: Удаление предыдущих файлов
# Удаление предыдущих созданных файлов по UI тестам
rm -rf index.html
rm -rf TestResults
rm -rf TestResults.xcresult
echo → ✅ Файлы успешно удалены

echo → Шаг 2: 📱 Сборка проекта и запуск UI тестов
# Сборка проекта и запуск UI тестов
xcodebuild \
 -workspace BankUI.xcworkspace \
 -scheme "BankUIUITests" \
 -sdk iphonesimulator \
 -destination 'platform=iOS Simulator,name=iPhone 11 Pro Max,OS=13.2.2' \
 -destination 'platform=iOS Simulator,name=iPhone 11 Pro,OS=13.2.2' \
 -destination 'platform=iOS Simulator,name=iPhone 11,OS=13.2.2' \
 -destination 'platform=iOS Simulator,name=iPhone 8 Plus,OS=13.2.2' \
 -destination 'platform=iOS Simulator,name=iPhone 8,OS=13.2.2' \
 -destination 'platform=iOS Simulator,name=iPhone SE,OS=13.2.2' \
 -resultBundlePath TestResults \
 test | xcpretty -s
echo → ✅ Проект был успешно собран и UI тесты пройдены

echo → Шаг 3: 📝 Создание отчета по UI тестам
# Создание отчета по UI тестам
xchtmlreport -r TestResults
echo → ✅ Отчет по UI тестам был создан

echo → Шаг 4: 📊 Открытие файла отчета
open index.html
