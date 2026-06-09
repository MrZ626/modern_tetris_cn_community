/*
代码来自2025.01.19的版本，估计是ts编译后的js所以有一定混淆，以下代码为修改过的参考用代码
删去了一些无关紧要（欸嘿）的内容，添加了各种注释

变量名缩略：
#define S this.S
#define Z this.S.zenith
#define SET this.S.setoptions
#define STAT this.S.stats
#define MOD_ this.SET.zenith_
#define MOD_xxxRev "xxx_reversed"===this.SET.zenith_mods[0]

部分变量名，供参照：
等级 rank
经验 climb_pts
升级疲劳 promotion_fatigue, rank_locked_until
犹豫攻击 hesitatedattacks
受击权重 targetingfactor
受击保护 targetinggrace
各种Mod zenith_[mod名]
逆位Mod [mod名]_reverse
间断洞位改变概率 messiness_change
连续洞位改变概率 messiness_inner
垃圾挖掘难度 garbagefavor
垃圾集中 messiness_center
垃圾行等待时间 garbagephase
*/

// 一些常数表
FloorDistance = [0, 50, 150, 300, 450, 650, 850, 1100, 1350, 1650, 1 / 0];
GravityBumps = [0, .48, .3, .3, .3, .3, .3, .3, .3, .3, .3];
GravLockDelay = [0, 30, 29, 28, 27, 26, 24, 22, 20, 18, 16];
GravRevLockDelay = [0, 24, 22, 20, 18, 16, 15, 14, 13, 12, 11];
SpeedrunReq = [7, 8, 8, 9, 9, 10, 0, 0, 0, 0, 0]; // [0]存的是不掉出去的等级
TargetingGrace = [0, 4.8, 3.9, 2.1, 1.4, 1.3, .9, .6, .4, .3, .2]; // 这不是受击保护属性，是受击保护的*释放间隔*，变量名没写完整，下面一个也是
TargetingGraceRevEx = [0, 1, .9, .8, .7, .6, .5, .4, .3, .2, .1];
RevNoHoldHoleSideChangeChance = [.1, .1, .15, .2, .25, .3, .35, .4, .45, .5, .55];
ReviveLevelIncrease = [1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3];
CancelingFatigueBumpCap = [4, 4, 5, 6, 7, 8, 9, 10, 1 / 0, 1 / 0, 1 / 0];
function GetSpeedCap(frame) {
    const t = this.FloorDistance.find((t => frame < t)) - frame;
    return Math.max(0, Math.min(1, t / 5 - .2))
}

// 主循环
function Loop() {
    const frame = this.self.esm.frame;
    let rank = Math.floor(STAT.zenith.rank);
    const height0 = STAT.zenith.altitude; // 记下用于卡层的高度

    // 经验流失
    if (frame >= Z.rank_locked_until) {
        let leakSpeed = _; // 单人:普通3专家5  双人:3+专家人数
        Z.climb_pts -= leakSpeed * (rank ** 2 + rank) / 3600 // climb_pts是当前经验
    }

    const nextRankXP = 4 * rank;
    const storedXP = 4 * (rank - 1);
    if (Z.climb_pts < 0)
        // 降级
        if (rank <= 1)
            // 不会掉到0级以下
            Z.climb_pts = 0;
        else {
            // 恢复计算总xp
            Z.climb_pts += storedXP;
            Z.last_rank_change_was_promote = false;
            rank--;
        }
    else if (Z.climb_pts >= nextRankXP) {
        // 清空xp升1级
        Z.climb_pts -= nextRankXP;
        Z.last_rank_change_was_promote = true;
        Z.rank_locked_until = frame + Math.max(60, 60 * (5 - Z.promotion_fatigue));
        Z.promotion_fatigue++;
        rank++;
    }

    // xp在5秒内不自然流失效果
    if (Z.last_rank_change_was_promote && Z.climb_pts >= 2 * (rank - 1))
        Z.promotion_fatigue = 0;

    // 计算小数等级……或者跳级!！如果一帧内获得大量经验升级后还有足够已将下一级填满的话就会瞬间跳级
    STAT.zenith.rank = rank + Z.climb_pts / (4 * rank);

    // 一些统计
    STAT.zenith.peakrank = Math.max(STAT.zenith.rank, STAT.zenith.peakrank);
    STAT.zenith.avgrankpts += STAT.zenith.rank;

    const o = STAT.zenith.altitude;
    const floor = me.GetFloorLevel(o);

    if (MOD_expertRev) {
        // 【专家+】的下坠
        STAT.zenith.altitude = Math.max(me.FloorDistance[floor - 1], o - .05 * (floor ** 2 + floor + 10) / 60);
    } else {
        // 推进器随时间爬升
        STAT.zenith.altitude += .25 * rank / 60 * me.GetSpeedCap(o);
    }

    // 平滑的高度变化
    if (Z.bonusremaining > 0)
        if (Z.bonusremaining <= .05) {
            STAT.zenith.altitude += Z.bonusremaining;
            Z.bonusremaining = 0;
        }
        else {
            const delta = Math.min(10, .1 * Z.bonusremaining);
            STAT.zenith.altitude += delta;
            Z.bonusremaining -= delta;
        }

    // 不让用“推进器随时间爬升”途径上楼
    if (SET.zenith_tutorial && STAT.zenith.altitude >= 50 && Z.tutorial.stage > 0 && Z.tutorial.stage < 5) {
        STAT.zenith.altitude = Math.min(49.99, height0);
        Z.bonusremaining = 0;
    }

    // 【重力(+)】
    floor !== STAT.zenith.floor && (
        MOD_gravity ? (S.g += me.GravityBumps[floor], SET.locktime = me.GLockDelay[floor]) : MOD_gravityRev && (S.g = 20, SET.locktime = me.GRLockDelay[floor]), Z.lastfloorchange = frame, 1 === floor ? S.glock = 240 : STAT.zenith.splits[floor - 2] = Math.round(this.self.lm.GetGameTime())
    )
    STAT.zenith.floor = floor;

    // 【专家+】的超时惩罚
    if (MOD_expertRev && frame - Z.lastfloorchange > 3600)
        SET.receivemultiplier += .005 / 60;

    // 测试服机器人模拟随机攻击
    if (S.TEMP_zenith_apm_cycle) {
        if (S.TEMP_zenith_apm_cycle += S.TEMP_zenith_apm / 3600 / 2.5 * (.75 + .5 * S.rngex.nextFloat()), S.TEMP_zenith_apm_cycle >= 1) {
            S.TEMP_zenith_apm_cycle--;
            this.self.atm.FightLines(S.rngex.nextFloat() >= .5 ? 4 : 1);
        }
    }

    // 某些机制的即死，估计是给【全旋+】用的
    if (this.self.atm.GetPendingGarbageCount() >= S.TEMP_zenith_instakill_at)
        this.self.gom.GameOver("garbagesmash");

    // 受击权重在3/5/7分钟增加
    if (frame === 10800 || frame === 18000 || frame === 25200)
        STAT.zenith.targetingfactor++;

    // 释放受击保护
    let r = 60 * (MOD_expertRev ? TargetingGrace : TargetingGraceRevEx)[floor];
    if (STAT.zenith.targetinggrace > 0 && frame >= S.lastatktime + r) {
        STAT.zenith.targetinggrace--;
        S.lastatktime = frame;
    }

    // 刷新混乱度
    const messy = (MOD_expert ? .05 : .03) * floor;
    if (MOD_messy) messy += .25;
    if (MOD_messyRev) messy += 1;
    if (MOD_allspinRev) messy += .3;
    SET.messiness_inner = messy;
    SET.messiness_change = 2.5 * messy;
    if (Z.maxmessy) {
        SET.messiness_change = 1;
        SET.messiness_inner = 1;
    }

    // 刷新垃圾集中的开关
    SET.messiness_center = SET.messiness_inner <= .15 && floor <= 5;
    if (MOD_volatileRev) {
        SET.garbagefavor = 50
        SET.messiness_center = true
    }

    // 垃圾挖掘难度
    SET.garbagefavor = (MOD_expert ? 0 : 33) - 3 * floor - (MOD_messy ? 25 : 0);

    // 垃圾行等待时间
    SET.garbagephase = MOD_expert ? 66 - 6 * floor : 165 - 15 * floor;
    if (MOD_anyRev && !MOD_expert)
        SET.garbagephase = (MOD_messyRev || MOD_volatileRev || MOD_doubleholeRev) ? 75 : [75, 75, 75, 75, 75, 75, 75, 60, 45, 30, 15][floor];

    // 垃圾行保护，根据垃圾行数量开关改变受击权重
    if (frame % 15 == 0 && (MOD_messyRev || MOD_doubleholeRev || MOD_allspinRev)) {
        const line = this.self.bm.CountGarbageLinesNoPerma();
        if (line !== Z.garbagerowcount) {
            const t = Math.max(0, 2.5 - .5 * Z.garbagerowcount);
            const n = Math.max(0, 2.5 - .5 * line);
            STAT.zenith.targetingfactor += n - t;
            Z.garbagerowcount = line;
        }
    }
}

// 一些方法
function getHolePosition() { // 计算垃圾行洞位置相关，主要是处理垃圾挖掘难度 （使用copilot整理过代码，不保证完全正确）
    let pos = 0;

    if (MOD_volatileRev) t.zenith.garbageahead.shift();

    if (t.setoptions.garbagefavor !== 0) {
        pos = function () {
            const scores = [];

            // 如果最高的一行有洞并且包含了灰色格子（垃圾行），记录左数第一个洞的位置为holePosAtTopLine
            // 感觉不太对……？是我理解错了还是真就代码写错了，我猜设计预期是找到最浅垃圾行的洞位置？
            let garbageHolePosAtTop = -1;
            for (let y = field.height - 1; y >= 0; y--) {
                let holePos = -1;
                let isGarbage = false;
                for (let x = 0; x < field.width; x++) {
                    if (holePos === -1 && null === t.board[y][x]) {
                        holePos = x;
                    }
                    if ("gb" === t.board[y][x]) {
                        isGarbage = true;
                    }
                }
                if (holePos !== -1) {
                    if (isGarbage) garbageHolePosAtTop = holePos;
                    break;
                }
            }

            // 对于每一列，先找到该列最低的空格，记录此列的“挖掘难度”
            e: for (let x = 0; x < field.width; x++) {
                for (let y = 0; y < field.height; y++) {
                    if (null !== t.board[y][x]) {
                        const r = garbageHolePosAtTop === -1 ? 0 : Math.abs(x - garbageHolePosAtTop);
                        scores.push([x, (field.height - y) + 5 * r + .1 * t.rngex.nextFloat()]);
                        continue e;
                    }
                }
                scores.push([x, .1 * t.rngex.nextFloat()]);
            }

            // 按照每列的挖掘难度从小到大排序（前面好挖 后面难挖）
            scores.sort((e, t) => e[1] - t[1]);

            // 根据垃圾挖掘难度计算每列的权重，也就是挑选挖掘难度的倾向
            // favor为0时每一列的权重都是10，也就是等概率，图像画出来是一条直线（虽然0的时候其实会跳过这些步骤，不用这么麻烦），正数的时候就会把这条直线绕中点(4.5，10)顺时针旋转，也就是增加前五项好挖的列的权重，减少后五项不好挖的列的权重（负权重计为0）
            let scoreSum = 0;
            for (let i = 0; i < scores.length; i++) {
                let score = Math.max(0, 10 + t.setoptions.garbagefavor + i * ((20 - 2 * (10 + t.setoptions.garbagefavor)) / 9));
                if (t.setoptions.messiness_nosame && t.lastcolumn === scores[i][0]) score = 0;
                if (MOD_volatileRev && (scores[i][0] < 2 || scores[i][0] >= e.bm.ColumnWidth() - 2)) score = 0;
                scoreSum += score;
                scores[i][2] = scoreSum;
            }

            // 以上一步计算的score为权重进行最终的随机选择（scoreSum是辅助变量，可以不管）
            const r = t.rngex.nextFloat() * scoreSum;
            for (let i = 0; i < scores.length; i++) {
                if (scores[i][2] !== 0 && r <= scores[i][2]) {
                    t.lastcolumn = scores[i][0];
                    return t.lastcolumn;
                }
            }

            // 如果意外情况没返回，默认返回0（应该是最左列？）
            return 0;
        }();
    } else {
        // 这块会受【双人+】影响，已过时
        if (t.setoptions.messiness_nosame && t.lastcolumn !== null) {
            pos = Math.floor(t.rngex.nextFloat() * (e.bm.ColumnWidth() - 1));
            if (pos >= t.lastcolumn) pos++;
        } else {
            pos = Math.floor(t.rngex.nextFloat() * e.bm.ColumnWidth());
        }
        t.lastcolumn = pos;

        if (MOD_volatileRev) {
            t.zenith.garbageahead.push(pos);
            t.lastcolumn = t.zenith.garbageahead[0];
            return t.lastcolumn;
        } else {
            return pos;
        }
    }
}

// 多段攻击相关（整理过代码）
function ExplodeAttack(atkObj) {
    t.garbageid--;

    let total = 16 + Math.max(Math.floor((t.stats.zenith.altitude - 3500) / 500), 0)
    if (MOD_volatile) total *= 2

    const secBase = Math.floor(total / 4)
    const remain = total - 4 * secBase
    const sections = [secBase, secBase, secBase, secBase]
    for (let i = 0; i < remain; i++) sections[3 - i]++;
    // 上面四行效果是把total尽量平均分成四份放入sections中，大的数字排在后，例如18变为[4,4,5,5]
    // 此处提供一个更简洁的写法：
    // const sections = []
    // for (let i = 0; i < 4; i++)
    //     sections[i] = Math.floor(total / 4) + (total % 4 >= 4 - i);

    let atk = atkObj.amt;
    const atkQueue = [];
    let id = 0;
    for (; atk > 0 && atkQueue.length < sections.length;) {
        const cut = Math.min(sections[id++], atk);
        atk -= cut
        atkQueue.push({
            ...atkObj,
            amt: cut,
            id: ++t.garbageid
        })
    }
    const countdown = 120 + 30 * atkQueue.length;
    t.windupwaituntil > e.esm.frame ? (e.wfm.WaitFrames(t.windupwaituntil - e.esm.frame, "start-explode-attack", atkQueue), t.windupwaituntil += countdown) : (StartExplodeAttack(atkQueue), t.windupwaituntil = e.esm.frame + countdown)
}
function StartExplodeAttack(t) {
    for (let n = 0; n < t.length; n++) e.wfm.WaitFrames(60 + 30 * n, "process-exploded-attack", t[n]);
    e.c.OnClient((() => {
        e.sfx.Play(`garbagewindup_${Math.max(1,Math.min(4,t.length))}`), e.hm.H.board.el("garbagewindupicon").create(Math.max(1, Math.min(4, t.length)))
    }))
}

// 一些事件
function AwardKill() { // 击杀
    this.GiveBonus(.25 * Math.floor(STAT.zenith.rank) * (MOD_expertRev ? 8 : 15))
}
function AwardLines(amount, giveHeight = true, giveXP = true) { // 非专家消行(false,true) / 抵消(false,true) / 发送(true,true)
    // 加高度（受mod等影响，见推进器章节表格）
    let dh = .25 * Math.floor(STAT.zenith.rank) * amount * (giveHeight ? 1 : 0);

    // 卡层时+3m
    const heightToNextFloor = me.FloorDistance.find((e => STAT.zenith.altitude < e)) - STAT.zenith.altitude - dh - Z.bonusremaining;
    if (heightToNextFloor >= 0 && heightToNextFloor <= 2) dh += 3;

    this.GiveBonus(dh);

    // 消行获取经验
    this.GiveClimbPts((amount + .05) * (giveXP ? 1 : 0));
}
function AwardHasBeenAttacked(amount) { // 被攻击
    const spaceRemain = Math.min(18 - STAT.zenith.targetinggrace, amount);
    if (spaceRemain > 0) STAT.zenith.targetinggrace += spaceRemain;
}
function GiveBonus(amount) { // 获取高度（各种途径）
    if (SET.zenith_tutorial && Z.tutorial.stage > 0 && Z.tutorial.stage < 5)
        amount *= me.GetSpeedCap(STAT.zenith.altitude);
    Z.bonusremaining += amount;
    if (this._bonusExpires < this.self.esm.frame) this._bonusCount = 0;
    this._bonusCount += amount;
    this._bonusExpires = this.self.esm.frame + 60;
    Z.bonusfromally += amount;
}
