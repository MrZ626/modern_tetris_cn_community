-- readme.md中的游戏表格从该数据库自动化生成，直接用lua执行该文件即可输出markdown格式的表格和脚注
-- 数据来自我的另一个仓库 https://github.com/26F-Studio/zita_revive/blob/main/task/zictionary_data.lua
-- 同步时间：2026.4.8

-- 修改脚注请改这里⬇
local footnote={
    -- [1]词条索引（在底下那13个连着的数字后第一个字符串，从里面任选一个看着方便的即可）
    -- [2]标注第几列（标题列为0，属性列从1开始）
    -- [3]脚注内容
    {"tech",5,"虽然多人服务器正在运行，但由于技术因素较难完成登录，也没有专门的联网玩法，只是实验性内容。"},
    {"io",13,"仅在单人和多人的自定义模式下，提供相对有限的研究工具。"},
    {"js",8,"多人模式无法实时看到其他人场地。"},
    {"c4r",0,"也称 MC 俄罗斯方块。"},
    {"tgm",0,"俄罗斯方块特级大师系列，街机风游戏。前两作可在 Nintendo Switch 购买复刻版体验，另有 TGM4-AE 在 Steam 有售。"},
    {"tgm",10,"原本是街机游戏，但也有电脑移植版。"},
    {"t99",6,"作为 DLC 内容出现。"},
    {"屁块",0,"链接提供的是 farter 的魔改版，也称「屁块」。"},
    {"屁块",8,"不支持自定义布局，只能在几个预设布局间切换。"},
    {"beat",0,"IOS独占。"},
    {"quadra break",0,"被DMCA然后下架了。"},
    {"环游记",0,"授权到期且未续约，已停服。"},
}
local gameDatabase={
    --热帅免 新 多单 键 手网计 参 官 研 （热门 音画质量 免费 创新 多人 单人 可调键位 手机 网页 电脑 参数可调 官方 研究工具）
    {3,2,2,2,1,2,2,2,0,2,2,0,2,"tech;techmino;铁壳;铁壳米诺","Techmino","studio26f.org","大规模缝合了常见现代块内容，可练习可挑战\n目前最新版本0.17.21，可以和约好友联机对战\n苹果用户见 #铁壳ios #铁壳mac"},
    {3,2,2,1,2,2,2,0,2,2,2,0,1,"io;tetrio;tetr.io","TETR.IO","tetr.io","应该是目前全世界在线人数最多的现代块游戏\n另见#io qp2"},
    {3,2,0,2,2,2,2,0,0,2,0,2,0,"tec;tetris effect;tetris effect connected","Tetris Effect: Connected","store.steampowered.com/app/1003590","卖点是沉浸音画体验和基于创新的Zone机制的各种模式（包括多人在线不对称竞技）"},
    {3,2,0,1,2,2,2,0,0,2,0,2,0,"ppt;puyo puyo tetris;ppt2;ppt2s","Puyo Puyo Tetris","store.steampowered.com/app/546050","包含Tetris和PuyoPuyo两个下落消除游戏，二者间可以对战\n注：PPT2的手感据很多人说都不行"},
    {3,0,2,1,2,2,2,1,2,2,2,0,1,"js;jstris","Jstris","jezevec10.com",""},
    {2,2,2,2,2,2,2,0,2,2,2,0,0,"wwc;worldwide combos","Worldwide Combos","worldwidecombos.com","有几种不同风格的大规则（例如炸弹垃圾行），有录像战（匹配对手不是真人）"},
    {2,2,2,2,2,2,2,0,0,2,2,0,0,"c2;cultris2;cultris ii","Cultris II","gewaltig.net","对战的主要玩法是基于时间的连击，考验玩家速度/Wide打法/挖掘，另单人游戏有一大堆创意模式"},
    {2,2,2,2,1,2,2,0,0,2,2,0,1,"sd;spirit drop","Spirit Drop","rayblastgames.com/spiritdrop.php","除了几个主模式外还有一个变革模式包含几十个创意规则可挑战"},
    {2,2,2,2,0,2,2,2,2,2,2,2,0,"gems;tetris gems","Tetris Gems","tetris.com/play-tetrisgems","限时1分钟挖掘，有Cascade，有三种消除后可以获得不同功能的宝石方块"},
    {2,2,2,2,0,2,2,2,0,2,2,0,1,"C::Reactris;c4r;c::r;Reactris","C::Reactris","b23.tv/BV13u411G75m","在方块里加入了丰富的Minecraft元素，有大量创意玩法"},
    {2,2,2,2,0,2,2,2,0,2,2,0,0,"aqm;aquamino","Aquamino","aqua6623.itch.io/aquamino","除了基础的单机模式外还有冰风暴、多线程、激光、雷暴等创意模式"},
    {2,2,2,2,0,2,2,0,0,2,2,0,1,"chextris","Chextris","chemicalex.itch.io/chextris","在方块里加入了音游元素，也有40L等基础模式"},
    {2,2,2,2,0,2,2,0,0,2,2,0,0,"tetra chroma;chroma","Tetra Chroma","store.steampowered.com/app/2702490",""},
    {2,2,2,2,0,2,2,0,0,2,2,0,0,"poly;polyform","Polyform","stellartophat.itch.io/polyform","有三角形和六边形的单元格"},
    {2,2,2,1,0,2,2,0,0,2,0,0,0,"example block game;ebg","Example Block Game","github.com/Oshisaure/example-block-game","一个仿TGM的街机方块游戏，有一个不区分szi正反朝向的旋转系统"},
    {2,2,2,0,2,2,2,2,0,0,2,0,0,"jj;jj块","JJ tetris","","JJ棋牌平台下的“JJ比赛”app内的一个休闲游戏（看不到可能是因为限制了新玩家不可见）","是现代方块但：竖屏，可自定义ASD/ASP，能自定义键位，无Hold，无B2B，无攻击缓冲不可抵消，每次攻击上限为4，连击较强"},
    {2,2,2,0,2,2,2,2,0,0,2,0,0,"引力星球;引力","引力星球","","引力星球app内的一个休闲游戏"},
    {2,2,2,0,0,2,1,1,1,1,0,2,0,"nes","Tetris (NES, Nintendo)","","最普及的经典俄罗斯方块之一，因各种因素硬抗住了方块现代化的进程活到了现在，CTWC比赛用的就是这个游戏"},
    {2,2,1,1,2,2,2,0,2,2,2,0,1,"god of stackers;gos","God of Stackers","godofstackers.com","有角色、技能、抽卡系统，目前还在开发阶段"},
    {2,2,1,1,0,2,2,1,0,1,0,2,0,"tgm;tetris the grand master;tetris grand master;tgm3;tgm2;铁门","TGM(1-3代)","","聚焦于高重力快节奏玩法，S13/GM等称号都出自该作，其中TGM3比较普遍，部分模式说明发送“##”查看","铁门 部分模式中到了特定分数时若超过了时间要求会强制结束游戏\nMaster 有段位评价，拿到更高段位点的要求有：连击(非消一)和消四，字幕战中消除和通关，每100分的前70分小于`min(标准时间, 上一个0~70秒数+2)`，每100总用时不超过限定值（否则扣分）\nShirase 类似于techmino中的20G-极限，高速20G开局，500~1000涨垃圾行，1000~1300为骨块，1300后大方块字幕战；段位结算为分数/100向下取整（1300为S13）若通关字幕战S13会变金色"},
    {2,2,0,2,0,2,2,0,0,2,2,0,1,"betrix","Betrix","store.steampowered.com/app/2007710","在方块里加入了音游元素，也有40L等基础模式"},
    {2,2,0,1,2,2,2,0,0,2,0,0,0,"tetra esports;tes","Tetra eSports","tetraesports.com/","Tetra Online转生，目前还在开发阶段"},
    {2,2,0,1,2,1,1,0,0,0,0,2,0,"t99;tetris 99","Tetris 99","","主打99人混战的吃鸡模式，也有一些常用单机模式如马拉松等\n游戏基础模式有NS Online会员可以免费玩，其他单机模式需要额外购买"},
    {2,1,2,2,2,0,2,0,2,2,2,0,0,"tetrio.io;tetrioio;ioio","TETRIO.IO","tetrio.io","无hold有next的对战块，但两个玩家在同一个场地的两头拔河，说不太清总之很好玩，有简单的分数系统能匹配对战，或者约好友\n注：本游戏和TETR.IO完全无关"},
    {2,1,2,2,0,2,2,1,2,2,2,0,0,"屁块;tetrjs;tetr.js","Tetr.js","farter.cn/t","tetr.js的一个衍生版本，有较多创意模式，触屏只能选预设布局不能自定义"},
    {2,1,2,2,0,2,2,0,2,2,2,0,0,"asc;ascension","Ascension","asc.winternebs.com","有一些创意模式，ASC旋转系统就来自这里"},
    {2,1,2,0,1,2,2,0,2,2,0,0,0,"nuke;nuketris","Nuketris","nuketris.com","有几个基础单机模式和1V1排位"},
    {2,0,2,2,2,1,2,1,2,2,2,0,0,"kos;king of stackers","King of Stackers","kingofstackers.com/games.php","主要玩法类似下棋，每个人以7块为一个回合轮流操作，策略性很强"},
    {2,0,2,0,0,2,2,1,2,2,0,0,2,"ttt","TTT","(翻译后挂在茶服的版本) teatube.cn/TTT","现代方块特殊操作手把手教程，推荐能全部消四完成40L挑战的人学习，内含极简、SRS、T-Spin、部分对战定式等内容的教程"},
    {2,0,2,0,0,2,2,1,2,2,0,0,2,"ttpc","TTPC","(翻译后挂在茶服的版本) teatube.cn/ttpc","SRS+Bag7方块游戏全消开局定式的教程（只能键盘操作）。推荐完成了TTT的人学习（必须先学会SRS）"},
    {2,0,2,0,0,2,2,1,2,2,0,0,2,"tpo","TPO","47.92.33.38/tpo","由TCV100制作的题库网站，内含部分nazo的题"},
    {2,0,2,0,0,2,2,1,2,2,0,0,2,"nazo","NAZO","(翻译后挂在茶服的版本) teatube.cn/nazo","内含各种T-Spin/All-Spin题目，简单到极难题目都有"},
    {1,2,2,2,1,2,2,0,0,2,0,0,0,"dtet","DTET","dtet.zui.jp/dtet/index.html","基于经典规则添加了20G和强大的人体工学方块控制系统"},
    {1,2,2,2,0,2,2,0,0,2,2,0,0,"thm;touhoumino","Touhoumino","www.touhoumino.com/","一个Nullpomino的mod版，在方块里加入了东方Project元素","马拉松模式结合东方Project里的“符卡”机制，需要在一定时间内达成目标分数才能击破。难度较大，适合有方块基础并且各项能力都较强的玩家游玩（不然都不知道自己怎么死的）"},
    {1,2,2,1,0,2,2,2,2,2,2,2,0,"mind bender;tetris mind bender","Tetris Mind Bender","play.tetris.com/mindbender","在马拉松基础上添加了效果，场地上会随机冒出效果方块，消除后会得到各种各样或好或坏的效果"},
    {1,2,2,1,0,2,2,1,1,1,2,0,2,"apotris","Apotris","akouzoukos.com/apotris","GBA上的现代块，设置齐全，模式较丰富"},
    {1,2,2,1,0,2,2,0,2,2,2,0,0,"tl;tetra legends","Tetra Legends","tetralegends.app","有两个隐藏的节奏模式，并且将一些其他游戏中不可见的机制进行了可视化，动效也很多。于2020年12月基本确定由于各种原因不再继续开发"},
    {1,2,2,1,0,2,2,0,0,2,2,0,1,"misa;misamino","Misamino","","比较工具的游戏，与AI进行回合制对战，可以导入外部AI程序"},
    {1,2,2,1,0,2,2,0,0,2,2,0,0,"剑桥;cambridge","Cambridge","github.com/Tetro48/cambridge","致力于创建一个轻松高度自定义新模式的方块平台。最初由Joe Zeng开发，于2020年10月8日0.1.5版开始Milla接管了开发。 — Tetris Wiki."},
    {1,2,2,1,0,2,2,0,0,2,0,0,0,"hebo;heboris","Heboris","","一个仿街机方块游戏，可以模拟多个方块游戏的部分模式"},
    {1,2,2,0,2,2,0,2,0,0,0,2,0,"royale;tetris royale;tetris n3twork;tetris n3t","Tetris (N3TWORK)","","N3TWORK开发，现由Play Studio运营"},
    {1,2,2,0,0,2,2,2,2,2,2,2,0,"tetris.com","tetris.com","play.tetris.com","只有马拉松一个模式，但有一个智能鼠标控制的玩法"},
    {1,2,2,0,0,2,2,0,0,2,0,0,0,"tex;texmaster","Texmaster","","TGM的社区自制游戏，包含TGM的所有模式，可以用来练习TGM，但World规则不完全一样（如软降到底无锁延，踢墙表有细节不同等）"},
    {1,2,1,1,0,2,1,0,0,1,0,2,0,"sega;sega tetris","Sega Tetris","","1999年发行的主机游戏，有1v1道具战，六种不同的消除方式能发送特殊效果"},
    {1,2,0,1,0,2,2,0,0,2,1,2,1,"tetris forever;forever;永恒;永恒篇","Tetris Forever","store.steampowered.com/app/3180240","俄罗斯方块40周年作，总体上是一个电子展览馆而不是游戏，按Tetris的历史发展排列了一份纪录片和各种图片资料，还内置了模拟器用来体验一些老游戏"},
    {1,2,0,1,0,2,0,2,0,0,0,2,0,"beat;tetris beat","Tetris Beat","","N3TWORK代理的一款移动端方块，除了马拉松外有“Beat模式”，根据BGM的节奏落块得到额外分数，但体验一般，特效还比较瞎眼"},
    {1,1,2,1,2,2,2,2,1,2,0,0,0,"fl;falling lightblocks","Falling Lightblocks","mrstahlfelge.itch.io/lightblocks","主要内容是经典块复刻和半实时对战"},
    {1,1,2,1,1,2,2,0,0,2,2,0,1,"np;nullpomino","Nullpomino","github.com/nullpomino/nullpomino","整个游戏自定义程度极高，甚至可以模拟出puyopuyo，但模式资源可能比较难找"},
    {1,1,2,1,0,2,2,0,0,2,0,0,0,"T-ex","T-ex","farter.cn/index.htm","Farter早年制作的一个基于flash的仿TGM游戏，包含一个创新旋转系统 #XRS"},
    {1,1,2,0,2,0,2,0,0,2,0,0,0,"火拼;火拼俄罗斯","火拼俄罗斯","qqgame.qq.com/app/gamedetail_11.shtml","腾讯游戏大厅的方块，12宽场地的经典块，攻击方式只有消4打3和消3打2，垃圾行为国际象棋棋盘式，几乎不可能挖掘"},
    {1,1,2,0,0,2,2,0,0,2,0,0,0,"mob;master of block","Master of Block","","一个仿街机方块游戏系列"},
    {1,0,2,1,0,2,2,0,0,2,2,0,2,"four;fourtris;four-tris","Four-tris","","单机自由沙盘，可以方便地随时自定义序列、绘制和删除地形、撤销和前进步骤，有截图识别地形功能，有多个练习模式，非常适合进行各种练习、复盘、绘制地形"},
    {1,0,2,0,0,2,2,2,2,2,2,0,2,"ztrix","Ztrix","ztrix-game.web.app","TEC的Zone练习用工具游戏，有自定义序列和撤销和出题等功能"},
    {1,0,2,0,0,2,0,2,2,2,0,0,2,"fumen;方块谱;编辑器;铺面","Fumen","fumen.zui.jp  knewjade.github.io/fumen-for-mobile","一个方块版面编辑器，可以用于分享定式，PC解法等。"},
    {0,2,2,2,0,2,0,2,0,0,0,2,0,"ea;tetris ea","（离线）Tetris (EA)","","EA代理的一款宇宙主题的移动端方块。有滑动操控和单点触控两种操作模式，已于2020年4月下架","除经典的马拉松外还有一个星系模式（地图挖掘），有重力连锁机制，目标是在限定块数内消除所有地图块"},
    {0,2,2,0,2,2,2,0,0,2,1,2,0,"to;top;toj;tos;tetris online","（私服）Tetris Online","","主要用来6人内对战/单挑/刷每日40L榜/挖掘模式/打机器人","现在还开着的服务器有：TO-P（波兰服，服务器在波兰，可能会卡顿）；TO-S（研究服，研究群群友自己开的服更稳定）"},
    {0,2,2,0,2,2,2,0,0,2,0,0,0,"tetra online","（离线）Tetra Online","离线版本 github.com/Juan-Cartes/Tetra-Offline/releases/tag/1.0","UI部分模仿了PPT，音乐不错，攻击特效好看，于2020年12月9日收到来自TTC的DMCA警告信于是被迫停止开发，在一段时间后关服并下架Steam"},
    {0,2,2,0,2,2,1,0,2,2,1,2,0,"tf;tetris friends;notris;notrisfoes","（私服）Tetris Friends","私服：notrisfoes.com","以前人比较多，后来官服倒闭了热度没了"},
    {0,2,1,2,0,2,0,2,0,0,0,2,0,"闪电战;tetris blitz","（离线）Tetris Blitz","","EA代理的一款移动端方块，有重力连锁机制，限时2分钟，已于2020年4月下架\n另见 #Blitz模式","持续消行会进入Frenzy模式（场地下方会不断冒出垃圾行，帮助玩家制造大连锁，如果多次落块没有消行会强制结束Frenzy）。有非常多的道具\n当新出现的方块与场地现有方块重叠时，场地最上方的几行会被自动清除，游戏不结束"},
    {0,2,0,2,1,2,0,0,0,2,0,2,0,"ultimate;tetris ultimate","（离线）Tetris Ultimate","store.steampowered.com/app/316750","有周期隐形/山体滑坡/双人同版等有趣模式，目前已下架"},
    {0,2,0,2,0,2,2,0,0,2,2,0,0,"quadra break;qb","（下线）Quadra Break","","以那些广告里疯狂cascade超宽屏方块为灵感的游戏\n已逝，永远怀念"},
    {0,2,0,1,0,2,2,2,0,0,0,2,0,"环游记;俄罗斯方块环游记;journey;tetris journey","（下线）Tetris Journey","","国内第一款正版授权手游方块。有闯关模式、对战模式和几个单机模式。闯关模式有各种各样有趣规则大多数有重力连锁，已于2023年2月15日停服"},
}

local ins = table.insert
local sheet = {}
for i = 1, #gameDatabase do
    local d = gameDatabase[i]
    local l = {}
    if #d[16] > 0 then
        d[16] = d[16]:match("%w%S+")
        ins(l, "[" .. d[15] .. "](" .. d[16] .. ")")
    else
        ins(l, d[15])
    end
    for j = 1, 13 do
        if j == 1 then d[j] = d[j] - 1 end
        ins(l, d[j] == 2 and "√" or d[j] == 1 and "o" or d[j] == 0 and "-" or "x")
        if j == 8 then ins(l, "") end
    end
    ins(sheet, l)
end
for i = 1, #footnote do
    local n = footnote[i]
    local found
    for j = 1, #gameDatabase do
        local keywords = (";" .. gameDatabase[j][14] .. ";"):lower()
        if keywords:find(";" .. n[1]:lower() .. ";") then
            sheet[j][n[2] + 1] = sheet[j][n[2] + 1] .. "[^" .. i .. "]"
            found = true
            break
        end
    end
    assert(found, "Footnote keyword not found in database: " .. n[1])
end

-- Output markdown table and notes
print("| 游戏 | 热门 | 音画 | 免费 | 创新 | 多人 | 单人 | 改键 | 手机 | | 网页 | 电脑 | 可调移动 | 官方 | 工具 |")
print("| - | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | - | :-: | :-: | :-: | :-: | :-: |")
for i = 1, #sheet do print("|" .. table.concat(sheet[i], "|") .. "|") end
print("")
for i = 1, #footnote do print("[^" .. i .. "]: " .. footnote[i][3]) end
