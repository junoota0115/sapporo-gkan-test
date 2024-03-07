class Gkan::DefaultSetting
  attr_reader :site

  def initialize(site)
    @site = site
  end

  def create_settings
    create_rate
    create_duty_settings
    create_leave
    create_leave_settings
  end

  def create_rate
    puts "# gkan rates"
    # 125/100
    @gkan_rt001 = save_rate name: "125/100", code: "0001", order: 10
    # 135/100
    @gkan_rt001 = save_rate name: "135/100", code: "0002", order: 20
    # 140/100
    @gkan_rt001 = save_rate name: "140/100", code: "0003", order: 30
    # 150/100
    @gkan_rt001 = save_rate name: "150/100", code: "0004", order: 40
    # 160/100
    @gkan_rt001 = save_rate name: "160/100", code: "0005", order: 50
    # 165/100
    @gkan_rt001 = save_rate name: "165/100", code: "0006", order: 60
    # 175/100
    @gkan_rt001 = save_rate name: "175/100", code: "0007", order: 70
  end

  def create_duty_settings
    puts "# gkan duty_settings"
    @gkan_ds001 = save_duty_setting name: "[札幌] 事務局長・総合職", code: "0001", order: 10,
      employee_type: "regular13g",
      in_worktime_week_hour: 38, in_worktime_week_minute: 45,
      in_worktime_day_hour: 7, in_worktime_day_minute: 45
    @gkan_ds002 = save_duty_setting name: "[札幌] 児童指導員", code: "0002", order: 20,
      employee_type: "regular13g",
      in_worktime_week_hour: 38, in_worktime_week_minute: 45,
      in_worktime_day_hour: 7, in_worktime_day_minute: 45
    @gkan_ds003 = save_duty_setting name: "[札幌] 児童指導員", code: "0003", order: 30,
      employee_type: "regular13g",
      in_worktime_week_hour: 33, in_worktime_week_minute: 00,
      in_worktime_day_hour: 7, in_worktime_day_minute: 45
    @gkan_ds004 = save_duty_setting name: "[札幌] 児童指導員", code: "0004", order: 40,
      employee_type: "regular13g",
      in_worktime_week_hour: 30, in_worktime_week_minute: 00,
      in_worktime_day_hour: 7, in_worktime_day_minute: 45
    @gkan_ds005 = save_duty_setting name: "[札幌] 職場限定職員", code: "0005", order: 50,
      employee_type: "regular13g",
      in_worktime_week_hour: 38, in_worktime_week_minute: 45,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds006 = save_duty_setting name: "[札幌] 職場限定職員", code: "0006", order: 60,
      employee_type: "regular13g",
      in_worktime_week_hour: 30, in_worktime_week_minute: 00,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds007 = save_duty_setting name: "[札幌] 再任用職員（A）", code: "0007", order: 70,
      employee_type: "regular13g",
      in_worktime_week_hour: 38, in_worktime_week_minute: 45,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds008 = save_duty_setting name: "[札幌] 再任用職員（B）", code: "0008", order: 80,
      employee_type: "regular13g",
      in_worktime_week_hour: 31, in_worktime_week_minute: 00,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds009 = save_duty_setting name: "[札幌] 再任用職員（C）", code: "0009", order: 90,
      employee_type: "regular13g",
      in_worktime_week_hour: 24, in_worktime_week_minute: 00,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds010 = save_duty_setting name: "[札幌] 再任用職員（D）", code: "0010", order: 100,
      employee_type: "parttimer",
      in_worktime_week_hour: 20, in_worktime_week_minute: 00,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds011 = save_duty_setting name: "[札幌] 主任パートスタッフ", code: "0011", order: 110,
      employee_type: "parttimer",
      in_worktime_week_hour: 20, in_worktime_week_minute: 00,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds012 = save_duty_setting name: "[札幌] 専門指導員", code: "0012", order: 120,
      employee_type: "regular13g",
      in_worktime_week_hour: 38, in_worktime_week_minute: 45,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds013 = save_duty_setting name: "[札幌] 専門指導員", code: "0013", order: 130,
      employee_type: "regular13g",
      in_worktime_week_hour: 33, in_worktime_week_minute: 00,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds014 = save_duty_setting name: "[札幌] 専門指導員", code: "0014", order: 140,
      employee_type: "regular13g",
      in_worktime_week_hour: 30, in_worktime_week_minute: 00,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds015 = save_duty_setting name: "[札幌] サポートスタッフ", code: "0015", order: 150,
      employee_type: "regular13g",
      in_worktime_week_hour: 38, in_worktime_week_minute: 45,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds016 = save_duty_setting name: "[札幌] サポートスタッフ", code: "0016", order: 160,
      employee_type: "regular13g",
      in_worktime_week_hour: 30, in_worktime_week_minute: 00,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds017 = save_duty_setting name: "[札幌] 臨時職員", code: "0017", order: 170,
      employee_type: "regular13g",
      in_worktime_week_hour: 38, in_worktime_week_minute: 45,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds018 = save_duty_setting name: "[札幌] 臨時職員", code: "0018", order: 180,
      employee_type: "regular13g",
      in_worktime_week_hour: 33, in_worktime_week_minute: 00,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds019 = save_duty_setting name: "[札幌] パートタイム職員（A）", code: "0019", order: 190,
      employee_type: "parttimer",
      in_worktime_week_hour: 20, in_worktime_week_minute: 00,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds020 = save_duty_setting name: "[札幌] パートタイム職員（B）", code: "0020", order: 200,
      employee_type: "parttimer",
      in_worktime_week_hour: 20, in_worktime_week_minute: 00,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds021 = save_duty_setting name: "[千歳] 児童指導員", code: "0021", order: 210,
      employee_type: "regular13g",
      in_worktime_week_hour: 38, in_worktime_week_minute: 45,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds022 = save_duty_setting name: "[千歳] 児童指導員", code: "0022", order: 220,
      employee_type: "regular13g",
      in_worktime_week_hour: 30, in_worktime_week_minute: 00,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds023 = save_duty_setting name: "[千歳] 再任用職員（1）", code: "0023", order: 230,
      employee_type: "regular13g",
      in_worktime_week_hour: 38, in_worktime_week_minute: 45,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds024 = save_duty_setting name: "[千歳] 再任用職員（2）", code: "0024", order: 240,
      employee_type: "regular13g",
      in_worktime_week_hour: 30, in_worktime_week_minute: 00,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds025 = save_duty_setting name: "[千歳] 再任用職員（3）", code: "0025", order: 250,
      employee_type: "parttimer",
      in_worktime_week_hour: 20, in_worktime_week_minute: 00,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds026 = save_duty_setting name: "[千歳] 主任パートスタッフ", code: "0026", order: 260,
      employee_type: "parttimer",
      in_worktime_week_hour: 19, in_worktime_week_minute: 00,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds026 = save_duty_setting name: "[千歳] 主任パートスタッフ", code: "0027", order: 270,
      employee_type: "parttimer",
      in_worktime_week_hour: 15, in_worktime_week_minute: 00,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds027 = save_duty_setting name: "[千歳] 専門指導員", code: "0028", order: 280,
      employee_type: "regular13g",
      in_worktime_week_hour: 38, in_worktime_week_minute: 45,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds028 = save_duty_setting name: "[千歳] 専門指導員", code: "0029", order: 290,
      employee_type: "regular13g",
      in_worktime_week_hour: 33, in_worktime_week_minute: 00,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds029 = save_duty_setting name: "[千歳] 専門指導員", code: "0030", order: 300,
      employee_type: "regular13g",
      in_worktime_week_hour: 30, in_worktime_week_minute: 00,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds030 = save_duty_setting name: "[千歳] サポートスタッフ", code: "0031", order: 310,
      employee_type: "regular13g",
      in_worktime_week_hour: 38, in_worktime_week_minute: 45,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds031 = save_duty_setting name: "[千歳] サポートスタッフ", code: "0032", order: 320,
      employee_type: "regular13g",
      in_worktime_week_hour: 30, in_worktime_week_minute: 00,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds032 = save_duty_setting name: "[千歳] サポートスタッフ", code: "0033", order: 330,
      employee_type: "regular13g",
      in_worktime_week_hour: 15, in_worktime_week_minute: 00,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds033 = save_duty_setting name: "[千歳] 臨時職員", code: "0034", order: 340,
      employee_type: "regular13g",
      in_worktime_week_hour: 38, in_worktime_week_minute: 45,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds034 = save_duty_setting name: "[千歳] 臨時職員", code: "0035", order: 350,
      employee_type: "regular13g",
      in_worktime_week_hour: 30, in_worktime_week_minute: 00,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
    @gkan_ds035 = save_duty_setting name: "[千歳] パートタイム職員", code: "0036", order: 360,
      employee_type: "parttimer",
      in_worktime_week_hour: 10, in_worktime_week_minute: 00,
      in_worktime_day_hour: 7, in_worktime_day_minute: 4
  end

  def create_leave
    puts "# gkan leaves"
    #年次有給休暇
    @gkan_l001 = save_leave name: "年次有給休暇", code: "0001", leave_type: "annual_leave", order: 10
    #リフレッシュ休暇(職務専念義務の免除)
    @gkan_l002 = save_leave name: "リフレッシュ休暇", code: "0002", leave_type: "other", order: 20
    #病気休暇(私傷病)
    @gkan_l003 = save_leave name: "病気休暇（私傷病）", code: "0003", leave_type: "other", order: 30
    #病気休暇(公傷病)
    @gkan_l004 = save_leave name: "病気休暇（公傷病）", code: "0004", leave_type: "other", order: 40
    #特別休暇 結婚
    @gkan_l005 = save_leave name: "特別休暇 結婚", code: "0005", leave_type: "special_leave", order: 50
    #特別休暇 忌引き
    @gkan_l006 = save_leave name: "特別休暇 忌引き", code: "0006", leave_type: "special_leave", order: 60
    #特別休暇 父母等の祭日
    @gkan_l007 = save_leave name: "特別休暇 父母等の祭日", code: "0007", leave_type: "special_leave", order: 70
    #特別休暇 生理
    @gkan_l008 = save_leave name: "特別休暇 生理", code: "0008", leave_type: "special_leave", order: 80
    #特別休暇 出産
    @gkan_l009 = save_leave name: "特別休暇 出産", code: "0009", leave_type: "special_leave", order: 90
    #特別休暇 育児時間
    @gkan_l010 = save_leave name: "特別休暇 育児時間", code: "0010", leave_type: "special_leave", order: 100
    #特別休暇 通勤緩和措置
    @gkan_l011 = save_leave name: "特別休暇 通勤緩和措置", code: "0011", leave_type: "special_leave", order: 110
    #特別休暇 子の看護休暇
    @gkan_l012 = save_leave name: "特別休暇 子の看護休暇", code: "0012", leave_type: "special_leave", order: 120
    #特別休暇 妊産婦の通院
    @gkan_l013 = save_leave name: "特別休暇 妊産婦の通院", code: "0013", leave_type: "special_leave", order: 130
    #特別休暇 妊娠障害
    @gkan_l014 = save_leave name: "特別休暇 妊娠障害", code: "0014", leave_type: "special_leave", order: 140
    #特別休暇 出産補助
    @gkan_l015 = save_leave name: "特別休暇 出産補助", code: "0015", leave_type: "special_leave", order: 150
    #特別休暇 現住居滅失破壊
    @gkan_l016 = save_leave name: "特別休暇 現住居滅失破壊", code: "0016", leave_type: "special_leave", order: 160
    #特別休暇 永年勤続
    @gkan_l017 = save_leave name: "特別休暇 永年勤続", code: "0017", leave_type: "special_leave", order: 170
    #介護休業
    @gkan_l018 = save_leave name: "介護休業", code: "0018", leave_type: "other", order: 180
    #介護休暇
    @gkan_l019 = save_leave name: "介護休暇", code: "0019", leave_type: "other", order: 190
    #出生時育児休業
    @gkan_l020 = save_leave name: "出生時育児休業", code: "0020", leave_type: "other", order: 200
    #育児休業
    @gkan_l021 = save_leave name: "育児休業", code: "0021", leave_type: "other", order: 210
    #部分休業
    @gkan_l022 = save_leave name: "部分休業", code: "0022", leave_type: "other", order: 220
    #欠勤
    @gkan_l023 = save_leave name: "欠勤", code: "0023", leave_type: "other", order: 230
  end

  def create_leave_settings
    puts "# gkan leave_settings"
    #[札幌] 職員就業規則(一般除く)
    @gkan_ls001 = save_leave_setting name: "[札幌] 職員就業規則（一般除く）", order: 10
    @gkan_ls001.tap do |setting|
      #年次有給休暇
      save_leave_unit setting: setting, leave_id: @gkan_l001.id
      #リフレッシュ休暇(職務専念義務の免除)
      save_leave_unit setting: setting, leave_id: @gkan_l002.id
      #病気休暇(私傷病)
      save_leave_unit setting: setting, leave_id: @gkan_l003.id, paid_type: "unpaid"
      #病気休暇(公傷病)
      save_leave_unit setting: setting, leave_id: @gkan_l004.id, paid_type: "unpaid"
      #特別休暇 結婚
      save_leave_unit setting: setting, leave_id: @gkan_l005.id, paid_type: "unpaid"
      #特別休暇 忌引き
      save_leave_unit setting: setting, leave_id: @gkan_l006.id, paid_type: "paid"
      #特別休暇 父母等の祭日
      save_leave_unit setting: setting, leave_id: @gkan_l007.id, paid_type: "paid"
      #特別休暇 生理
      save_leave_unit setting: setting, leave_id: @gkan_l008.id, paid_type: "paid"
      #特別休暇 出産
      save_leave_unit setting: setting, leave_id: @gkan_l009.id, paid_type: "paid"
      #特別休暇 育児時間
      save_leave_unit setting: setting, leave_id: @gkan_l010.id
      #特別休暇 通勤緩和措置
      save_leave_unit setting: setting, leave_id: @gkan_l011.id
      #特別休暇 子の看護休暇
      save_leave_unit setting: setting, leave_id: @gkan_l012.id
      #特別休暇 妊産婦の通院
      save_leave_unit setting: setting, leave_id: @gkan_l013.id
      #特別休暇 妊娠障害
      save_leave_unit setting: setting, leave_id: @gkan_l014.id
      #特別休暇 出産補助
      save_leave_unit setting: setting, leave_id: @gkan_l015.id
      #特別休暇 現住居滅失破壊
      save_leave_unit setting: setting, leave_id: @gkan_l016.id, paid_type: "paid"
      #特別休暇 永年勤続
      save_leave_unit setting: setting, leave_id: @gkan_l017.id, paid_type: "unpaid"
      #介護休業
      save_leave_unit setting: setting, leave_id: @gkan_l018.id, paid_type: "paid"
      #介護休暇
      save_leave_unit setting: setting, leave_id: @gkan_l019.id, paid_type: "paid"
      #出生時育児休業
      save_leave_unit setting: setting, leave_id: @gkan_l020.id, paid_type: "paid"
      #育児休業
      save_leave_unit setting: setting, leave_id: @gkan_l021.id, paid_type: "paid"
      #部分休業
      save_leave_unit setting: setting, leave_id: @gkan_l022.id, paid_type: "paid"
      #欠勤
      save_leave_unit setting: setting, leave_id: @gkan_l023.id
    end

    #[札幌] 職員就業規則(一般)
    @gkan_ls002 = save_leave_setting name: "[札幌] 職員就業規則（一般）", order: 20
    @gkan_ls002.tap do |setting|
      #年次有給休暇
      save_leave_unit setting: setting, leave_id: @gkan_l001.id
      #リフレッシュ休暇(職務専念義務の免除)
      save_leave_unit setting: setting, leave_id: @gkan_l002.id
      #病気休暇(私傷病)
      save_leave_unit setting: setting, leave_id: @gkan_l003.id, paid_type: "unpaid"
      #病気休暇(公傷病)
      save_leave_unit setting: setting, leave_id: @gkan_l004.id, paid_type: "unpaid"
      #特別休暇 結婚
      save_leave_unit setting: setting, leave_id: @gkan_l005.id, paid_type: "unpaid"
      #特別休暇 忌引き
      save_leave_unit setting: setting, leave_id: @gkan_l006.id, paid_type: "paid"
      #特別休暇 生理
      save_leave_unit setting: setting, leave_id: @gkan_l008.id, paid_type: "paid"
      #特別休暇 出産
      save_leave_unit setting: setting, leave_id: @gkan_l009.id, paid_type: "paid"
      #特別休暇 育児時間
      gkan_lu010 = save_leave_unit setting: setting, leave_id: @gkan_l010.id
      #特別休暇 通勤緩和措置
      save_leave_unit setting: setting, leave_id: @gkan_l011.id
      #特別休暇 子の看護休暇
      save_leave_unit setting: setting, leave_id: @gkan_l012.id
      #特別休暇 妊産婦の通院
      save_leave_unit setting: setting, leave_id: @gkan_l013.id
      #特別休暇 現住居滅失破壊
      save_leave_unit setting: setting, leave_id: @gkan_l016.id, paid_type: "paid"
      #特別休暇 永年勤続
      save_leave_unit setting: setting, leave_id: @gkan_l017.id, paid_type: "unpaid"
      #介護休業
      save_leave_unit setting: setting, leave_id: @gkan_l018.id, paid_type: "paid"
      #介護休暇
      save_leave_unit setting: setting, leave_id: @gkan_l019.id, paid_type: "paid"
      #出生時育児休業
      save_leave_unit setting: setting, leave_id: @gkan_l020.id, paid_type: "paid"
      #育児休業
      save_leave_unit setting: setting, leave_id: @gkan_l021.id, paid_type: "paid"
      #部分休業
      save_leave_unit setting: setting, leave_id: @gkan_l022.id, paid_type: "paid"
      #欠勤
      save_leave_unit setting: setting, leave_id: @gkan_l023.id
    end

    #[札幌] 児童指導員就業規則(33h)
    @gkan_ls003 = save_leave_setting name: "[札幌] 児童指導員就業規則（33h）", order: 30
    @gkan_ls003.tap do |setting|
      #年次有給休暇
      save_leave_unit setting: setting, leave_id: @gkan_l001.id
      #リフレッシュ休暇(職務専念義務の免除)
      save_leave_unit setting: setting, leave_id: @gkan_l002.id
      #病気休暇(私傷病)
      save_leave_unit setting: setting, leave_id: @gkan_l003.id, paid_type: "unpaid"
      #病気休暇(公傷病)
      save_leave_unit setting: setting, leave_id: @gkan_l004.id, paid_type: "unpaid"
      #特別休暇 結婚
      save_leave_unit setting: setting, leave_id: @gkan_l005.id, paid_type: "unpaid"
      #特別休暇 忌引き
      save_leave_unit setting: setting, leave_id: @gkan_l006.id, paid_type: "paid"
      #特別休暇 生理
      save_leave_unit setting: setting, leave_id: @gkan_l008.id, paid_type: "paid"
      #特別休暇 出産
      save_leave_unit setting: setting, leave_id: @gkan_l009.id, paid_type: "paid"
      #特別休暇 育児時間
      gkan_lu010 = save_leave_unit setting: setting, leave_id: @gkan_l010.id
      #特別休暇 通勤緩和措置
      save_leave_unit setting: setting, leave_id: @gkan_l011.id
      #特別休暇 子の看護休暇
      save_leave_unit setting: setting, leave_id: @gkan_l012.id
      #特別休暇 妊産婦の通院
      save_leave_unit setting: setting, leave_id: @gkan_l013.id
      #特別休暇 現住居滅失破壊
      save_leave_unit setting: setting, leave_id: @gkan_l016.id, paid_type: "paid"
      #特別休暇 永年勤続
      save_leave_unit setting: setting, leave_id: @gkan_l017.id, paid_type: "unpaid"
      #介護休業
      save_leave_unit setting: setting, leave_id: @gkan_l018.id, paid_type: "paid"
      #介護休暇
      save_leave_unit setting: setting, leave_id: @gkan_l019.id, paid_type: "paid"
      #出生時育児休業
      save_leave_unit setting: setting, leave_id: @gkan_l020.id, paid_type: "paid"
      #育児休業
      save_leave_unit setting: setting, leave_id: @gkan_l021.id, paid_type: "paid"
      #欠勤
      save_leave_unit setting: setting, leave_id: @gkan_l023.id
    end

    #[札幌] 児童指導員就業規則(30h)
    @gkan_ls004 = save_leave_setting name: "[札幌] 児童指導員就業規則（30h）", order: 40
    @gkan_ls004.tap do |setting|
      #年次有給休暇
      save_leave_unit setting: setting, leave_id: @gkan_l001.id
      #リフレッシュ休暇(職務専念義務の免除)
      save_leave_unit setting: setting, leave_id: @gkan_l002.id
      #病気休暇(私傷病)
      save_leave_unit setting: setting, leave_id: @gkan_l003.id, paid_type: "unpaid"
      #病気休暇(公傷病)
      save_leave_unit setting: setting, leave_id: @gkan_l004.id, paid_type: "unpaid"
      #特別休暇 結婚
      save_leave_unit setting: setting, leave_id: @gkan_l005.id, paid_type: "unpaid"
      #特別休暇 忌引き
      save_leave_unit setting: setting, leave_id: @gkan_l006.id, paid_type: "paid"
      #特別休暇 生理
      save_leave_unit setting: setting, leave_id: @gkan_l008.id, paid_type: "paid"
      #特別休暇 出産
      save_leave_unit setting: setting, leave_id: @gkan_l009.id, paid_type: "paid"
      #特別休暇 育児時間
      gkan_lu010 = save_leave_unit setting: setting, leave_id: @gkan_l010.id
      #特別休暇 通勤緩和措置
      save_leave_unit setting: setting, leave_id: @gkan_l011.id
      #特別休暇 子の看護休暇
      save_leave_unit setting: setting, leave_id: @gkan_l012.id
      #特別休暇 妊産婦の通院
      save_leave_unit setting: setting, leave_id: @gkan_l013.id
      #特別休暇 現住居滅失破壊
      save_leave_unit setting: setting, leave_id: @gkan_l016.id, paid_type: "paid"
      #介護休業
      save_leave_unit setting: setting, leave_id: @gkan_l018.id, paid_type: "paid"
      #介護休暇
      save_leave_unit setting: setting, leave_id: @gkan_l019.id, paid_type: "paid"
      #出生時育児休業
      save_leave_unit setting: setting, leave_id: @gkan_l020.id, paid_type: "paid"
      #育児休業
      save_leave_unit setting: setting, leave_id: @gkan_l021.id, paid_type: "paid"
      #欠勤
      save_leave_unit setting: setting, leave_id: @gkan_l023.id
    end

    #[札幌] 児童指導員就業規則(フル)
    gkan_ls005 = save_leave_setting name: "[札幌] 児童指導員就業規則（フル）", order: 50
    gkan_ls005.tap do |setting|
      #年次有給休暇
      save_leave_unit setting: setting, leave_id: @gkan_l001.id
      #リフレッシュ休暇(職務専念義務の免除)
      save_leave_unit setting: setting, leave_id: @gkan_l002.id
      #病気休暇(私傷病)
      save_leave_unit setting: setting, leave_id: @gkan_l003.id, paid_type: "unpaid"
      #病気休暇(公傷病)
      save_leave_unit setting: setting, leave_id: @gkan_l004.id, paid_type: "unpaid"
      #特別休暇 結婚
      save_leave_unit setting: setting, leave_id: @gkan_l005.id, paid_type: "unpaid"
      #特別休暇 忌引き
      save_leave_unit setting: setting, leave_id: @gkan_l006.id, paid_type: "paid"
      #特別休暇 生理
      save_leave_unit setting: setting, leave_id: @gkan_l008.id, paid_type: "paid"
      #特別休暇 出産
      save_leave_unit setting: setting, leave_id: @gkan_l009.id, paid_type: "paid"
      #特別休暇 育児時間
      gkan_lu010 = save_leave_unit setting: setting, leave_id: @gkan_l010.id
      #特別休暇 通勤緩和措置
      save_leave_unit setting: setting, leave_id: @gkan_l011.id
      #特別休暇 子の看護休暇
      save_leave_unit setting: setting, leave_id: @gkan_l012.id
      #特別休暇 妊産婦の通院
      save_leave_unit setting: setting, leave_id: @gkan_l013.id
      #特別休暇 現住居滅失破壊
      save_leave_unit setting: setting, leave_id: @gkan_l016.id, paid_type: "paid"
      #介護休業
      save_leave_unit setting: setting, leave_id: @gkan_l018.id, paid_type: "paid"
      #介護休暇
      save_leave_unit setting: setting, leave_id: @gkan_l019.id, paid_type: "paid"
      #出生時育児休業
      save_leave_unit setting: setting, leave_id: @gkan_l020.id, paid_type: "paid"
      #育児休業
      save_leave_unit setting: setting, leave_id: @gkan_l021.id, paid_type: "paid"
      #部分休業
      save_leave_unit setting: setting, leave_id: @gkan_l022.id, paid_type: "paid"
      #欠勤
      save_leave_unit setting: setting, leave_id: @gkan_l023.id
    end

    #[札幌] 職場限定職員就業規則(フル)
    @gkan_ls006 = save_leave_setting name: "[札幌] 児童指導員就業規則（フル）", order: 60
    @gkan_ls006.tap do |setting|
      #年次有給休暇
      save_leave_unit setting: setting, leave_id: @gkan_l001.id
      #リフレッシュ休暇(職務専念義務の免除)
      save_leave_unit setting: setting, leave_id: @gkan_l002.id
      #病気休暇(私傷病)
      save_leave_unit setting: setting, leave_id: @gkan_l003.id, paid_type: "unpaid"
      #病気休暇(公傷病)
      save_leave_unit setting: setting, leave_id: @gkan_l004.id, paid_type: "unpaid"
      #特別休暇 結婚
      save_leave_unit setting: setting, leave_id: @gkan_l005.id, paid_type: "unpaid"
      #特別休暇 忌引き
      save_leave_unit setting: setting, leave_id: @gkan_l006.id, paid_type: "paid"
      #特別休暇 生理
      save_leave_unit setting: setting, leave_id: @gkan_l008.id
      #特別休暇 出産
      save_leave_unit setting: setting, leave_id: @gkan_l009.id, paid_type: "paid"
      #特別休暇 育児時間
      gkan_lu010 = save_leave_unit setting: setting, leave_id: @gkan_l010.id
      #特別休暇 通勤緩和措置
      save_leave_unit setting: setting, leave_id: @gkan_l011.id
      #特別休暇 子の看護休暇
      save_leave_unit setting: setting, leave_id: @gkan_l012.id
      #特別休暇 妊産婦の通院
      save_leave_unit setting: setting, leave_id: @gkan_l013.id
      #特別休暇 現住居滅失破壊
      save_leave_unit setting: setting, leave_id: @gkan_l016.id, paid_type: "paid"
      #介護休業
      save_leave_unit setting: setting, leave_id: @gkan_l018.id, paid_type: "paid"
      #介護休暇
      save_leave_unit setting: setting, leave_id: @gkan_l019.id, paid_type: "paid"
      #出生時育児休業
      save_leave_unit setting: setting, leave_id: @gkan_l020.id, paid_type: "paid"
      #育児休業
      save_leave_unit setting: setting, leave_id: @gkan_l021.id, paid_type: "paid"
      #部分休業
      save_leave_unit setting: setting, leave_id: @gkan_l022.id, paid_type: "paid"
      #欠勤
      save_leave_unit setting: setting, leave_id: @gkan_l023.id
    end

    #［札幌］職場限定職員就業規則(30h)
    @gkan_ls007 = save_leave_setting name: "[札幌] 職場限定職員就業規則", order: 70
    @gkan_ls007.tap do |setting|
      #年次有給休暇
      save_leave_unit setting: setting, leave_id: @gkan_l001.id
      #リフレッシュ休暇(職務専念義務の免除)
      save_leave_unit setting: setting, leave_id: @gkan_l002.id
      #病気休暇(私傷病)
      save_leave_unit setting: setting, leave_id: @gkan_l003.id, paid_type: "unpaid"
      #病気休暇(公傷病)
      save_leave_unit setting: setting, leave_id: @gkan_l004.id, paid_type: "unpaid"
      #特別休暇 結婚
      save_leave_unit setting: setting, leave_id: @gkan_l005.id, paid_type: "unpaid"
      #特別休暇 忌引き
      save_leave_unit setting: setting, leave_id: @gkan_l006.id, paid_type: "paid"
      #特別休暇 生理
      save_leave_unit setting: setting, leave_id: @gkan_l008.id
      #特別休暇 出産
      save_leave_unit setting: setting, leave_id: @gkan_l009.id, paid_type: "paid"
      #特別休暇 育児時間
      gkan_lu010 = save_leave_unit setting: setting, leave_id: @gkan_l010.id
      #特別休暇 通勤緩和措置
      save_leave_unit setting: setting, leave_id: @gkan_l011.id
      #特別休暇 子の看護休暇
      save_leave_unit setting: setting, leave_id: @gkan_l012.id
      #特別休暇 妊産婦の通院
      save_leave_unit setting: setting, leave_id: @gkan_l013.id
      #特別休暇 現住居滅失破壊
      save_leave_unit setting: setting, leave_id: @gkan_l016.id, paid_type: "paid"
      #介護休業
      save_leave_unit setting: setting, leave_id: @gkan_l018.id, paid_type: "paid"
      #介護休暇
      save_leave_unit setting: setting, leave_id: @gkan_l019.id, paid_type: "paid"
      #出生時育児休業
      save_leave_unit setting: setting, leave_id: @gkan_l020.id, paid_type: "paid"
      #育児休業
      save_leave_unit setting: setting, leave_id: @gkan_l021.id, paid_type: "paid"
      #欠勤
      save_leave_unit setting: setting, leave_id: @gkan_l023.id
    end

    #[札幌] 再任用職員就業規則
    @gkan_ls008 = save_leave_setting name: "[札幌] 再任用職員就業規則", order: 80
    @gkan_ls008.tap do |setting|
      #年次有給休暇
      save_leave_unit setting: setting, leave_id: @gkan_l001.id
      #リフレッシュ休暇(職務専念義務の免除)
      save_leave_unit setting: setting, leave_id: @gkan_l002.id
    end

    #[札幌] 主任パートスタッフ就業規則
    @gkan_ls009 = save_leave_setting name: "[札幌] 主任パートスタッフ就業規則", order: 90
    @gkan_ls009.tap do |setting|
      #年次有給休暇
      save_leave_unit setting: setting, leave_id: @gkan_l001.id
      #病気休暇(私傷病)
      save_leave_unit setting: setting, leave_id: @gkan_l003.id, paid_type: "paid"
      #病気休暇(公傷病)
      save_leave_unit setting: setting, leave_id: @gkan_l004.id, paid_type: "paid"
      #特別休暇 忌引き
      save_leave_unit setting: setting, leave_id: @gkan_l006.id, paid_type: "paid"
      #特別休暇 生理
      save_leave_unit setting: setting, leave_id: @gkan_l008.id, paid_type: "paid"
      #特別休暇 出産
      save_leave_unit setting: setting, leave_id: @gkan_l009.id, paid_type: "paid"
      #特別休暇 通勤緩和措置
      save_leave_unit setting: setting, leave_id: @gkan_l011.id
      #特別休暇 子の看護休暇
      save_leave_unit setting: setting, leave_id: @gkan_l012.id
      #特別休暇 妊産婦の通院
      save_leave_unit setting: setting, leave_id: @gkan_l013.id
      #特別休暇 現住居滅失破壊
      save_leave_unit setting: setting, leave_id: @gkan_l016.id, paid_type: "paid"
      #介護休業
      save_leave_unit setting: setting, leave_id: @gkan_l018.id, paid_type: "paid"
      #介護休暇
      save_leave_unit setting: setting, leave_id: @gkan_l019.id, paid_type: "paid"
      #出生時育児休業
      save_leave_unit setting: setting, leave_id: @gkan_l020.id, paid_type: "paid"
      #育児休業
      save_leave_unit setting: setting, leave_id: @gkan_l021.id, paid_type: "paid"
      #欠勤
      save_leave_unit setting: setting, leave_id: @gkan_l023.id
    end

    #[札幌] 専門指導員等就業規則
    @gkan_ls010 = save_leave_setting name: "[札幌] 専門指導員等就業規則", order: 100
    @gkan_ls010.tap do |setting|
      #年次有給休暇
      save_leave_unit setting: setting, leave_id: @gkan_l001.id
      #リフレッシュ休暇(職務専念義務の免除)
      save_leave_unit setting: setting, leave_id: @gkan_l002.id
      #病気休暇(私傷病)
      save_leave_unit setting: setting, leave_id: @gkan_l003.id, paid_type: "unpaid"
      #病気休暇(公傷病)
      save_leave_unit setting: setting, leave_id: @gkan_l004.id, paid_type: "unpaid"
      #特別休暇 結婚
      save_leave_unit setting: setting, leave_id: @gkan_l005.id, paid_type: "unpaid"
      #特別休暇 忌引き
      save_leave_unit setting: setting, leave_id: @gkan_l006.id, paid_type: "paid"
      #特別休暇 生理
      save_leave_unit setting: setting, leave_id: @gkan_l008.id
      #特別休暇 出産
      save_leave_unit setting: setting, leave_id: @gkan_l009.id, paid_type: "paid"
      #特別休暇 育児時間
      gkan_lu010 = save_leave_unit setting: setting, leave_id: @gkan_l010.id
      #特別休暇 通勤緩和措置
      save_leave_unit setting: setting, leave_id: @gkan_l011.id
      #特別休暇 子の看護休暇
      save_leave_unit setting: setting, leave_id: @gkan_l012.id
      #特別休暇 妊産婦の通院
      save_leave_unit setting: setting, leave_id: @gkan_l013.id
      #特別休暇 現住居滅失破壊
      save_leave_unit setting: setting, leave_id: @gkan_l016.id, paid_type: "paid"
      #介護休業
      save_leave_unit setting: setting, leave_id: @gkan_l018.id, paid_type: "paid"
      #介護休暇
      save_leave_unit setting: setting, leave_id: @gkan_l019.id, paid_type: "paid"
      #出生時育児休業
      save_leave_unit setting: setting, leave_id: @gkan_l020.id, paid_type: "paid"
      #育児休業
      save_leave_unit setting: setting, leave_id: @gkan_l021.id, paid_type: "paid"
      #部分休業
      save_leave_unit setting: setting, leave_id: @gkan_l022.id, paid_type: "paid"
      #欠勤
      save_leave_unit setting: setting, leave_id: @gkan_l023.id
    end

    #[札幌] 期間雇用職員等就業規則
    @gkan_ls011 = save_leave_setting name: "[札幌] 期間雇用職員等就業規則", order: 110
    @gkan_ls011.tap do |setting|
      #年次有給休暇
      save_leave_unit setting: setting, leave_id: @gkan_l001.id
      #病気休暇(公傷病)
      save_leave_unit setting: setting, leave_id: @gkan_l004.id, paid_type: "unpaid"
      #特別休暇 忌引き
      save_leave_unit setting: setting, leave_id: @gkan_l006.id, paid_type: "paid"
      #特別休暇 生理
      save_leave_unit setting: setting, leave_id: @gkan_l008.id
      #特別休暇 出産
      save_leave_unit setting: setting, leave_id: @gkan_l009.id, paid_type: "paid"
      #特別休暇 通勤緩和措置
      save_leave_unit setting: setting, leave_id: @gkan_l011.id
      #特別休暇 子の看護休暇
      save_leave_unit setting: setting, leave_id: @gkan_l012.id
      #特別休暇 妊産婦の通院
      save_leave_unit setting: setting, leave_id: @gkan_l013.id
      #特別休暇 現住居滅失破壊
      save_leave_unit setting: setting, leave_id: @gkan_l016.id, paid_type: "paid"
      #介護休業
      save_leave_unit setting: setting, leave_id: @gkan_l018.id, paid_type: "paid"
      #介護休暇
      save_leave_unit setting: setting, leave_id: @gkan_l019.id, paid_type: "paid"
      #育児休業
      save_leave_unit setting: setting, leave_id: @gkan_l021.id, paid_type: "paid"
      #部分休業
      save_leave_unit setting: setting, leave_id: @gkan_l022.id, paid_type: "paid"
      #欠勤
      save_leave_unit setting: setting, leave_id: @gkan_l023.id
    end

    # TODO [千歳]
  end

  private

  def save_duty_setting(data)
    cond = { site_id: site.id, name: data[:name], code: data[:code] }
    item = Gws::Gkan::DutySetting.find_or_initialize_by(cond)
    puts(item.new_record? ? "create #{data[:name]}" : "exists #{data[:name]}")

    item.attributes = data
    item.save!
    item
  end

  def save_leave(data)
    cond = { site_id: site.id, name: data[:name], code: data[:code] }
    item = Gws::Gkan::Leave.find_or_initialize_by(cond)
    puts(item.new_record? ? "create #{data[:name]}" : "exists #{data[:name]}")

    item.attributes = data
    item.save!
    item
  end

  def save_leave_setting(data)
    cond = { site_id: site.id, name: data[:name] }

    item = Gws::Gkan::LeaveSetting.find_or_initialize_by(cond)
    puts(item.new_record? ? "create #{data[:name]}" : "exists #{data[:name]}")

    item.attributes = data
    item.save!
    item
  end

  def save_leave_unit(data)
    puts " - #{data[:leave_id]}"
    item = Gws::Gkan::LeaveUnit.new(data)
    item.save!
    item
  end

  def save_rate(data)
    cond = { site_id: site.id, code: data[:code] }
    item = Gws::Gkan::Rate.find_or_initialize_by(cond)
    puts(item.new_record? ? "create #{data[:name]}" : "exists #{data[:name]}")

    item.attributes = data
    item.save!
    item
  end
end
