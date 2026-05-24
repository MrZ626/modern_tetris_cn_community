# 某 Guideline (2009版) 术语表

>在原文中用大写开头的“术语”都原样保留

**Back-to-Back** 形容词  
描述两个连续的特殊(消除)动作，比如两个消四中间没有隔着消一/二/三

**Block** 名词  
锁定在Matrix单元格中的单格的块，也叫“existing Block”

**Block Out** 名词  
游戏结束条件，“当新生成的Tetrimino有部分和场地中的块重合时”

**Broken Line** 名词  
发送给对手的 包含一格空的 一行块  
在标准的多人方块对战游戏中，Broken Line的洞会在随机位置且

**Buffer Zone** 名词  
位于场地之上的10x20的不可见区域，用来检测Lock Out / Block Out / Top Out三种游戏结束条件

**Collapse** 动词  
消除时，所有位于消除行上方的已锁定的块会下落相同行数

**Counter Attack** 名词  
抵消对手攻击的攻击，防止垃圾行进入自己场地  
垃圾行要发送给对手前必须清空自己的Receiving Queue

**Facing** 名词  
每个Tetrimino有四个朝向 北/东/南/西，所有Next和Hold中的Tetrimino都以北朝向生成

**Fall Speed** 名词  
Tetrimino从顶部开始落下的速度

**Ghost Piece** 名词  
一个画面元素，指示Tetrimino如果就在当前位置下落到底后的位置
呈现为轮廓线或者半透明图像

**Goal** 名词  
Level Up或者Game Completed发生前的条件，一般是消除行数，由游戏具体的目标系统决定  
对于Fixed Goal System，每个level一定要消除10行，对于Variable Goal System，N-level要消除5*N行

**Hard Drop** 名词 动词  
Tetrimino立刻垂直落到和场地第一个接触的位置并锁定，不再能进一步操作

**Hold Queue** 名词  
一个存储空间，下落中的Tetrimino可以被玩家Hold进去，等到需要时再使用  
操作的时候，被Hold的Tetrimino和当前正在下落的Tetrimino互换位置，并且从顶部的生成位置重新开始下落

**Level Up** 名词  
完成一个关卡的目标后，玩家将进入下一个关卡

**Line** 名词  
Matrix中被填满的水平方向的一整行

**Line Attack** 名词  
发送给随机对手（随机选定或者随时间切换，取决于具体系统）的Broken Line或Solid Line，由以下动作发出：  
Double，Triple，Tetris，T-spin Single/Double/Triple

**Line Clear** 名词  
当水平方向的一整行被Block填满时，它会被从Matrix中移除，称为一个Line Clear  
所有在Line Clear上方的块会下落以填补空隙  
大多数Tetris游戏中会根据Line Clear获得分数等奖励，称为消行得分  
以下是八种类型的Line Clear：

- **Single** 消除一行  
- **Double** 消除两行  
- **Triple** 消除三行  
- **Tetris** 消除四行  
- **Mini T-spin Single** 用简单一些的T-spin消除一行  
- **T-spin Single** 用T-spin消除一行  
- **T-spin Double** 用T-spin消除两行  
- **T-spin Triple** 用T-spin消除三行

**Lock Down** 名词  
玩家不可再控制Tetrimino的时刻
通常是Tetrimino落到Surface上的0.5秒后

**Lock Down Timer** 名词  
Tetrimino落到Surface上的0.5秒的倒计时  
时间结束后Tetrimino会Lock Down并且不可再控制  
Lock Down Timer会根据 Classic / Infinite Placement Lock Down Rules重置

**Lock Out** 名词  
游戏结束条件，“当Tetrimino完全在Skyline之上锁定”

**Matrix** 名词  
定义了当前游戏区域的排列单元格的矩形，尺寸通常是10列20行高  
Tetrimino从顶部中央的刚好高于Skyline（屏幕外）的位置生成

**Mino** 名词  
构成Tetrimino的正方形基本单元  
四个Mino以不同方式连接构成的图案称为Tetrimino

**Next Queue** 名词  
显示写下来要放置的Next Tetrimino  
如果硬件允许，要显示六个Tetrimino

**Next Tetrimino** 名词  
将出现（生成）在Matrix正上方的Tetrimino

**Piece Edges** 名词  
一个Tetrimino的边缘/边界

**Receiving Queue** 名词  
一个垂直的量表，用来在每次落块间积累对手的Line Attack  
当一个Lock Down发生时，在新的Tetrimino生成前，Receiving Queue中的行会被添加到场地底部

**Rotation** 名词  
玩家对Tetrimino朝向的控制  
旋转以90度为单位，可以是顺时针或逆时针

**Skyline** 名词  
Matrix顶部的水平线  
Tetrimino从顶部中央的刚好高于Skyline的位置生成

**SoftDrop** 名词 动词  
让Tetrimino从当前位置开始加速（20倍于正常的Fall Speed）下落

**Solid Line** 名词  
一行没有空格的发送给对手的Blocks，一般不可消除

**Starting Lines** 名词  
游戏开始时就有的Broken Line或Solid Line  
一般用于在多人游戏中，以预设的或者随机的图案让游戏混乱一些

**Surface** 名词  
Matrix中任意Block的顶部，或者Matrix的底部

**Super Rotation System** 名词  
定义Tetrimino如何在Matrix中旋转的系统

**Target Mark** 名词  
一个会移动的标记，选定Line Attack的接受者  
这个标记显示在对手Matrix的中心附近，只对控制者可见

**Tetrimino** 名词  
由四个Mino边连接而成的“Tetris®图案”  
四个Mino总共可以构造出七个可能的Tetrimino，分别对应一个独特的颜色：  

- **O-Tetrimino** 黄色；正方形；四格构成2×2正方形
- **I-Tetrimino** 浅蓝色；形状像大写字母I；四格在一条直线上
- **T-Tetrimino** 紫色；形状像大写字母T；三格一排，中间上方多一格
- **L-Tetrimino** 橙色；形状像大写字母L；三格一排，左边上方多一格
- **J-Tetrimino** 深蓝色；形状像大写字母J；三格一排，右边上方多一格
- **S-Tetrimino** 绿色；形状像大写字母S；两个水平多米诺，一个放在另一个的右上方
- **Z-Tetrimino** 红色；形状像大写字母Z；两个水平多米诺，一个放在另一个的左上方

**Tetris Engine** 名词  
负责Tetris游戏逻辑的代码

**Top Out** 名词  
游戏结束条件，“收到New Block Line导致existing Block超出Buffer Zone范围”

**Top Out Line** 名词  
Buffer Zone的顶部，位于Skyline上方20行  
这是Tetris中的绝对最高点，仅在多人游戏中向对手发送Line Attack导致Top Out这个游戏结束条件时有意义

**Touch** 名词 动词  
Tetrimino与Matrix边缘或者Matrix内的块的接触

**T-Slot** 名词  
当T-Tetrimino被旋入其中时，与T-Tetrimino中心斜向相邻的四个角中有任意三个被existing Block占据的结构

**T-Spin** 名词  
使T-Tetrimino落入T-Slot中，然后在锁定前旋转的动作

**Visual Rotation Point** 名词  
使用Super Rotation System时靠近或者位于Tetrimino上的，游戏引擎尝试去围绕其旋转的点  
若旋转失败则会尝试Tetrimino上的下一个Visual Rotation Point直到成功

**Well** 名词  
在Matrix中块之间的垂直空洞。消除Tetris需要一个完美的单格宽、四格高的Well
