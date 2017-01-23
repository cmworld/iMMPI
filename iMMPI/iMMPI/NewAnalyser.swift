import Foundation

// TODO: rename later
struct NewAnalyser {
    let scales: [AnalysisScale]

    init(scales: [AnalysisScale]) {
        self.scales = scales
    }
}


extension NewAnalyser {
    init() {
        self.init(scales: [
            .group_reliability,             // А. НАДЕЖНОСТЬ
                .sr,                        //     Общественная диссимуляция
                .ds_r,                      //     Медицинская симуляция
                .ta,                        //     Комплекс Панурга
                .hy_s,                      //     Тенденция перечить
                .defensive_reaction,        //     Защитная реакция на тест
                .self_bashing,              //     Стремление наговорить на себя
            .group_health,                  // Б. Здоровье
                .maturity,                  //     Старость (зрелость)
                .nt,                        //     Потребность в лечении (пренебрежение здоровьем)
                .sv,                        //     Половая активность
                .sdv,                       //     Половые отклонения
                .a1,                        //     Алкоголизм 1
                .ad,                        //     Алкогольная дифференциация
                .a2,                        //     Алкоголизм 2
                .headaches,                 //     Предрасположенность к головным болям
                .soma_complaints,           //     Соматические жалобы
                .soma_reaction,             //     Реакция соматизации
                .physical_disorders,        //     Физические расстройства
                .mental_block,              //     Психическая заторможенность
                .epilepsy,                  //     Эпилепсия
                .nucleus_injury,            //     Органическое поражение хвостатого ядра
            .group_psyche,                  // В. ПСИХИКА
                .l,                         //     Ложь (неискренность)
                .f,                         //     Достоверность (невалидность)
                .k,                         //     Коррекция
                .hs,                        //     Ипохондрия (Сверхконтроль)
                    .hs_self,               //         Сверхконтроль Я (зажатость)
                    .hs_pre,                //         Предипохондрическое состояние
                    .hs_health,             //         Сосредоточенность на здоровье
                    .hs_pure,               //         Чистая ипохондрия
                    .hs_neurotic,           //         Невротический сверхконтроль
                    .hs_neurotic_weak,      //         Невротическое ослабление сверхконтроля
                .d,                         //     Депрессия (Пессимистичность)
                    .d_pure,                //         Чистая депрессия
                    .d_subjective,          //         Субъективная депрессия
                    .d_block,               //         Психомоторная заторможенность
                    .d_gloom,               //         Мрачность
                    .d_evident,             //         Явная депрессия
                    .d_reaction,            //         Депрессивная реакция
                    .d_mild,                //         Мягкая депрессия
                .hy,                        //     Истерия
                    .hy_immaturity,         //         Эмоциональная незрелость
                    .hy_pure,               //         Чистая истерия
                    .hy_evident,            //         Явная истерия
                    .hy_hidden,             //         Скрытая истерия
                    .hy_sensitivity,        //         Эмоциональная чувствительность
                .pd,                        //     Психопатия (Импульсивность)
                    .pd_impulsiveness,      //         Импульсивность
                    .pd_pure,               //         Чистая психопатия
                    .pd_evident,            //         Явные психопатические отклонения
                    .pd_hidden,             //         Скрытые психопатические отклонения
                    .pd_hostility,          //         Выраженная враждебность
                    .pd_accel,              //         Психомоторная акселерация
                    .pd_intended_hostility, //         Осознанная выраженная враждебность
                    .pd_hostility_control,  //         Контроль над враждебностью
                    .pd_aggro_suppression,  //         Подавление агрессии
                .mf,                        //     Половое развитие
                    .mf_femininity,         //         Женственность
            ])
    }
}
