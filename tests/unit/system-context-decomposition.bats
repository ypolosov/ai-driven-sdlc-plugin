#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  META="$REPO_ROOT/meta-templates/system-context.meta.md"
}

@test "B6.1: meta различает функциональную и конструктивную декомпозицию" {
  run grep -iE 'функциональн.*конструктивн|конструктивн.*функциональн' "$META"
  [ "$status" -eq 0 ]
}

@test "B6.1: meta вводит ось axis со значениями functional и constructive" {
  grep -qE '`axis`' "$META"
  grep -qF "functional" "$META"
  grep -qF "constructive" "$META"
}

@test "B6.1: meta ссылается на Левенчук Том 2 гл.7 для оси декомпозиции" {
  run grep -F "гл. 7" "$META"
  [ "$status" -eq 0 ]
}

@test "B6.1: meta предупреждает не смешивать код-модули с функц подсистемами" {
  run grep -iE 'модул.*код|код.*модул|репозитори.* не подсистем|не путать' "$META"
  [ "$status" -eq 0 ]
}
