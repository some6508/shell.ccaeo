# 𝘣𝘺 𝘤𝘤𝘢𝘦𝘰@ᴛɢ
export SOME=false
export APP_BY=𝘤𝘤𝘢𝘦𝘰@ᴛɢ
export HUB_URL="https://hub.fastgit.org"
export APP_URL="https://some6508.github.io"
export APP_GIT="https://git.ccaeo.workers.dev/"
export APP_DEV="https://url.ccaeo.workers.dev/?url="
export APP_AP="com.projectkr.shell.ActionPage"
if [[ -n $data_MD5 ]]; then
export SOME=true
export APP_NA=$Package_Name
export APP_UER=$Apk_UID
export APP_SDK=$SDK
export APP_VN="$Version_Name"
export APP_VC=$Version_Code
export APP_UID=$User_Id
export APP_ROOT=$Have_ROOT
export SD_DIR=$SD_PATH
export APP_TMP=$Cache_Dir
export APP_PATH=$TOOLKIT
export APP_EXE=$Run_PATH
export DA_DIR=$USER_DIR
export RUN=$HOME/run
export INI=$RUN/ini
export TMP=$RUN/tmp
export XML=$RUN/xml
export PAGE=$XML
export CCAEO=$RUN/ccaeo.sh
export BIN=$APP_PATH/bin
export PREFIX=$RUN/usr
export ABIN=$PREFIX/bin
export SBIN=$PREFIX/sbin
export XBIN=$PREFIX/xbin
export BBIN=$PREFIX/busybox
export PATH="${ABIN}:${SBIN}:${BIN}:${XBIN}:${PATH0}:${BBIN}"
[[ -d $RUN ]] && cd $RUN
fi
export APP_DOWN=$SD_DIR/Download/$APP_NA
export MOD_DIR=/data/adb/modules
export XCW=$TMP/XCW.ini
export TBIN=$DA_DIR/com.termux/files/usr/bin
export MBIN=$DA_DIR/bin.mt.plus/files/term/usr/bin
export SH_DOWN=$RUN/down.sh
export MOD_HTTP=$RUN/http_mod.sh
export LSP_HTTP=$RUN/http_lsp.sh
export XP_HTTP=$RUN/http_xp.sh
#Han.GJZS（2021111600_v1.0.2）
export PATH="$PATH:/data/data/Han.GJZS/files/usr"
export Package_Name="$APP_NA"
export APP_USER_ID="$APP_UER"
export SCRIPT="$APP_PATH"
export TOOLKIT="$APP_PATH"
export Data_Dir="$INI"
[[ -d $TMP ]] && SET=true || SET=false
$SET && set -x 2>$TMP/CCAEO.LOG && export PS4='$LINENO:	${FUNCNAME[0]}'
#$SET && exec 2>$TMP/CCAEO.LOG && set -x && export PS4='$LINENO: '
if [[ -f $INI/cdn.ini ]]; then
	export cdn=1
	export URL_DEV="$APP_DEV"
else
	export cdn=0
fi
{
local xxxx="$*"
if [[ "$1" = *_* ]]; then
	$@; return $?
fi
}
exit_pgrep() {
$SET && set -x 2>$TMP/EXIT.LOG
toast ">>>正在结束进程<<<
$$"
K=$(
for i in /proc/[0-9][0-9][0-9][0-9]*/cwd; do
	if [[ `readlink $i` = *$APP_NA* ]]; then
		echo ${i//\/cwd}
	fi
done
#ps -ef | grep "$APP_NA" | grep -v "grep" | sed -n 's/root//p' | awk '{print $1}'
#pidof "/$APP_NA"
#pgrep -f "$APP_NA/"
#pstree -p $$
)
K=`echo "${K//\/proc\/}" | sort -un`
toast "<<<已结束进程>>>
$K"
[[ -d $APP_PATH/cache ]] && rm -f $APP_PATH/cache/*
kill -1 $K &
pkill -f "$HOME"
}
mod_page() {
S_T; trap 'E_T -t 加载Magisk模块仓库2' EXIT; cxml
cat <<-CCAEO
<group>
	<action title="刷新界面" confirm="true" reload="true" auto-off="true" >
		<summary>可点击确定即可刷新</summary>
	</action>
</group>
<group>
CCAEO
toast ">>>正在加载Magisk模块仓库2<<<"
curl -s --connect-timeout 10 'https://api.github.com/users/Magisk-Modules-Repo/repos?sort=pushed&per_page=100' | egrep 'pushed_at|svn_url' | tr '\n' ' ' | sed -e 's/": /=/g' -e 's/"pushed_at/\npushed_at/g' -e 's/",     "svn_url/" svn_url/g' -e 's/",/"/g' | while read i; do
if [[ -n $i ]]; then
	((j++))
	eval "$i"
	name=${svn_url##*/}
	mod_time=`_time -tz $pushed_at`
#	eval "$(curl -s --connect-timeout 10 "${svn_url//github.com/api.github.com\/repos}/commits" | grep -m 1 'sha' | sed -n 's/.*"sha": "/sha="/p')"
	[[ -e $MOD_DIR/$name ]] && desc='该模块已安装'
	cat <<-CCAEO
		<action title="$j·$name" id="@$name" reload="@$name" >
			<set>mod_http_all &#34;$svn_url/archive/master.zip&#34; &#34;$name&#34;</set>
			<summary>- 获取时间：${mod_time:-获取失败}</summary>
			<desc>$desc</desc>
			<params>
				<param name="mod_b" title="文件链接" value="$svn_url/archive/master.zip" />
				<param name="mod_a" label="操作选项" options-sh="echo '1|下载安装\n2|仅下载\n3|打开文件链接'" />
				<param name="_rm" label="下载安装后删除文件" type="switch" />
				<param name="_js" label="使用CDN加速下载" type="switch" value="$cdn" />
			</params>
		</action>
	CCAEO
	unset i pushed_at svn_url mod_time name desc
fi
done
echo '</group>'
}
post() {
if [[ $# -ne 0 ]]; then
	su -lp 2000 -c "/system/bin/cmd notification post -S bigtext -t "$APP_NA" 'Tag' \"$*\""
fi
}
app_vc() {
if [[ -n $1 && -e $DA_DIR/$1 ]]; then
	local c
	c=`pm list packages --show-versioncode $1 | sed -n "s/.*$1 .*://p"`
	if [[ -z $c ]]; then
		c=`pm dump $1 | sed -n 's/.*versionCode=//p' | cut -f1 -d ' '`
		if [[ -z $c ]]; then
			appinfo -o vc -pn $1
			return $?
		fi
	fi
	echo "$c"
fi
}
app_vn() {
if [[ -n $1 && -e $DA_DIR/$1 ]]; then
	local vn
	vn=`pm dump $1 | grep -m 1 versionName | sed -n 's/.*=//p'`
	if [[ -z $vn ]]; then
		appinfo -o vn -pn $1
		return $?
	fi
	echo "$vn"
fi
}
ge_shi() {
if [[ $1 = -s ]]; then
	echo "$ge_shi" >$INI/ge_shi.ini
elif [[ $1 = -d ]]; then
	shift
	ge_shi="$@"
	if [[ $_ge = 1 ]]; then
	axm_all "$ge_shi"
	elif [[ $_ge = 2 ]]; then
	[[ -f "$ge_shi" ]] && rm -f "$ge_shi" && echo "- 已删除	$ge_shi"
	elif [[ $_ge = 3 ]]; then
		if [[ -d "$_mv" ]]; then
			[[ "${ge_shi%/*}" = "$_mv" ]] && abort "无法移动，所选目录与原目录相同"
			echo "- 正在移动	$ge_shi"
			if mv -f "$ge_shi" "$_mv"; then
				echo "- 已移动到	$_mv"
			else
				abort "移动到目录	$_mv	失败"
			fi
		else
			abort "所选目录不存在"
		fi
	elif [[ $_ge = 4 ]]; then
		file_dir "${ge_shi%/*}"
	fi
elif [[ -f $INI/ge_shi.ini ]]; then
	S_T; trap 'E_T -t 加载格式`cat $INI/ge_shi.ini`' EXIT
	cxml
	cat <<-CCAEO
	<group>
		<action title="查找格式" reload="true" auto-off="true" >
			<set>ge_shi -s</set>
			<params>
				<param name="ge_shi" title="请输入" placeholder="例：zip、apk" value-sh="cat \$INI/ge_shi.ini" />
			</params>
		</action>
	</group>
	CCAEO
	for i in `cat $INI/ge_shi.ini`; do
		find $SD_DIR -type f -iname "*.$i" | while read ge_shi; do
			if [[ -f "$ge_shi" ]]; then
				((M++))
				_size=`file_size "$ge_shi"`
				_time=`file_time "$ge_shi"`
				ge_shi=`echo "$ge_shi" | xml_cat`
				cat <<-CCAEO
				<group title="$M" >
					<action title="${ge_shi##*/}" >
						<set>ge_shi -d &#34;$ge_shi&#34;</set>
						<desc>模块大小：$_size&#x000A;创建时间：$_time&#x000A;模块目录：${ge_shi%/*}</desc>
						<params>
							<param name="_ge" label="选项" title="注意：安装仅支持	APK	和	Magisk	模块" options-sh="echo '1|安装\n2|删除\n3|移动\n4|跳转'" />
							<param name="_mv" title="移动目录" value="$ge_shi" type="folder" editable="true" />
						</params>
					</action>
				</group>
				CCAEO
			fi
		done
	done
else
	cxml
	cat <<-CCAEO
	<group>
		<action title="查找格式" reload="true" auto-off="true" >
			<set>ge_shi -s</set>
			<params>
				<param name="ge_shi" title="请输入" placeholder="例：zip、apk" value-sh="cat \$INI/ge_shi.ini" />
			</params>
		</action>
	</group>
	CCAEO
fi
}
ccaeo_acc() {
cat <<-'CCAEO'
# 𝘣𝘺 𝘤𝘤𝘢𝘦𝘰@ᴛɢ
#set -x
#export PS4='$LINENO: '
dev=/dev/.ccaeo
ini=/data/media/0/Download/ccaeo
DIR=/data/adb/modules/ccaeo_acc
moddir=$(magisk --path)/.magisk/busybox
PATH="$moddir:$dev/busybox:$PATH"
path=$0
dir=${0%/*}
file=${0##*/}
log=$ini/$file.log
if [[ ! -d $dev/busybox ]]; then
	mkdir -p $dev/busybox
	$moddir/busybox --install -s $dev/busybox
fi
mkdir -p $ini
if [[ ! -d $DIR ]]; then
	mkdir -p $DIR/sh
	touch $DIR/update
	cp -f $path $DIR/sh/ccaeo_acc.sh
	cat <<-CCAEO >$DIR/module.prop
	id=ccaeo_acc
	name=电池监控
	version=v1.0.1
	versionCode=2021122700
	author=𝘤𝘤𝘢𝘦𝘰@ᴛɢ
	description=日志写入在：$ini/ccaeo_acc.log，执行运行：$DIR/service.sh
	CCAEO
	cat <<-'CCAEO' >$DIR/service.sh
	#!/system/bin/sh
	# 𝘣𝘺 𝘤𝘤𝘢𝘦𝘰@ᴛɢ
	{
	set -x
	moddir=$(magisk --path)/.magisk/busybox
	PATH="$moddir:$dev/busybox:$PATH"
	dir=${0%/*}
	file=ccaeo_acc
	mkdir -p /dev/.ccaeo
	$moddir/busybox --install -s /dev/.ccaeo/busybox
	pkill -f "$dir/sh/"
	start-stop-daemon -bx $dir/sh/$file.sh -S
	}&
	CCAEO
	chmod -R 777 $DIR
	cat <<CCAEO
	模块已创建
	重启后生效
	不重启执行运行可前往：/data/adb/modules/ccaeo_acc/service.sh
	CCAEO
	exit 0
fi
cp -af $log $log.log
cd $dev;:>$log
exec 1>>$log 2>&1
cat <<-CCAEO
--------------------------------------------------
>>>首次开机等待解锁<<<
CCAEO
until (("`dumpsys window policy 2>/dev/null | sed -n 's/.*wing=//p' | grep -c 'false'`" != 0)); do printf '.'; sleep 1; done
echo
acca() {
cat <<-CCAEO
--------------------------------------------------
<<<开始运行电池监控>>>
PATH路径: $PATH
运行PID: $$
运行名称: $file
运行目录: $dir
完整路径: $path
运行时间: `date '+%Y年%m月%d日·周%u·%H点%M分%S秒'`
CCAEO
}
acca
me=`date '+%s'`
while :; do
_time() { echo "$@" | awk '{a=$0;if(a>=86400){d=a/86400;dd="天";printf("%.f%s",d,dd)};if(a>=3600){h=a%86400/3600;hh="小时";printf("%.f%s",h,hh)};if(a>=60){m=a%86400%3600/60;mm="分钟";printf("%.f%s",m,mm)};s=a%86400%3600%60;ss="秒";printf("%.f%s\n",s,ss)}'; }
acc() { eval "$(sed -n 's/POWER_SUPPLY//p' "/sys/class/power_supply/usb/uevent" | sed 's/=/="/g; s/$/"/g')
$(sed -n 's/POWER_SUPPLY//p' "/sys/class/power_supply/bms/uevent" | sed 's/=/="/g; s/$/"/g')"
if [[ $_CURRENT_NOW != -* ]]; then
	ACC=true; [[ -n $f ]] && unset f l
	[[ -z $e ]] && e=$_CAPACITY && j=`date +%s`
else
	ACC=false; [[ -n $e ]] && unset e j
	[[ -z $f ]] && f=$_CAPACITY && l=`date +%s`
fi
[[ -z $a ]] && a=`date +%s` && aa=$_CAPACITY
}
CAT() {
[[ -z `pgrep -f /acc` ]] && /data/adb/modules/acc/service.sh --init
[[ "$(du -k $log | cut -f 1)" -ge 256 ]] && :>$log && acca
cat <<-CCAEO
--------------------------------------------------
`dumpsys window policy | sed -n 's/.*howing=/息屏状态: /p'`
`dumpsys bluetooth_manager | sed -n 's/.*enabled:/蓝牙状态:/p'`
飞行模式: `settings get global airplane_mode_on`
️WiFi状态: `settings get global wifi_on`
定位状态: `settings get secure location_providers_allowed`
️电池温度: `awk "BEGIN{print $_TEMP/10}"`℃
电池容量: `awk 'BEGIN{printf("%2.2f%%",('$_CHARGE_FULL'/'$_CHARGE_FULL_DESIGN')*100)}'`
电池电流: `awk 'BEGIN{printf("%4.f",'$_CURRENT_NOW'/1000)}'`mA
电池电压: `awk 'BEGIN{printf("%4.f",'$_VOLTAGE_NOW'/1000)}'`mV
️估计容量: `awk "BEGIN{print $_CHARGE_FULL/1000}"`mAh
估计电流: `awk 'BEGIN{printf("%2.2f",'$_INPUT_CURRENT_NOW'/100000)}'`A
估计功率: `awk 'BEGIN{printf("%2.2f",'$_VOLTAGE_NOW'*'$_CURRENT_NOW'/1000000000000)}'`W
CCAEO
}
acc
if $ACC; then
	if [[ $aa != $_CAPACITY ]]; then
		b=`date +%s`
		let bb=b-a
		let cc=bb*_CAPACITY
		let jj=b-j
		let n=b-me
		let m=`date '+%s'`-`date '+%s' -d "$(uptime -s)"`
		unset a; CAT
		cat <<-CCAEO
		已减电量: `awk "BEGIN{print $e-$_CAPACITY}"`%
		️电量已从: $aa% >> $_CAPACITY%
		未充时间: `_time $jj`
		预计可用: `_time $cc`
		已运行了: `_time $n`
		已开机了: `_time $m`
		显示时间: `date '+%Y年%m月%d日·周%u·%H点%M分%S秒'`
		`dumpsys activity activities | sed -n 's/.*mResumedActivity.*{/前台应用: {/p'`
		`dumpsys activity activities | sed -n 's/.*lastLaunchTime=-/前台时长: /p' | sed -n '1p'`
		`dumpsys activity recents | sed -n 's/.*topActivity=/后台应用: /p'`
		CCAEO
	fi
else
	if [[ $aa != $_CAPACITY ]]; then
		b=`date +%s`
		let bb=b-a
		let cc=100-_CAPACITY
		let cc=bb*cc
		let ll=b-l
		let n=b-me
		let m=`date '+%s'`-`date '+%s' -d "$(uptime -s)"`
		unset a; CAT
		cat <<-CCAEO
		已充电量: `awk "BEGIN{print $_CAPACITY-$f}"`%
		已充容量: `awk 'BEGIN{printf("%2.2f%%",('$_CHARGE_COUNTER'/'$_CHARGE_FULL_DESIGN')*100)}'`
		️电量已从: $aa% >> $_CAPACITY%
		充电时间: `_time $ll`
		预计充满: `_time $cc`
		已运行了: `_time $n`
		已开机了: `_time $m`
		显示时间: `date '+%Y年%m月%d日·周%u·%H点%M分%S秒'`
		`dumpsys activity activities | sed -n 's/.*mResumedActivity.*{/前台应用: {/p'`
		`dumpsys activity activities | sed -n 's/.*lastLaunchTime=-/前台时长: /p' | sed -n '1p'`
		`dumpsys activity recents | sed -n 's/.*topActivity=/后台应用: /p'`
		CCAEO
	fi
fi
sleep 10
done
CCAEO
}
git_fail() {
cat <<-CCAEO >$1
`cxml`
<group>
	<action title="刷新仓库" confirm="true" reload="true" auto-off="true" >
		<set>rm -f $2</set>
		<summary>可点击确定即可刷新，默认每天只刷新一次</summary>
	</action>
</group>
`txml -g -s 25 '加载失败，可点击刷新仓库'`
CCAEO
}
xp_http() {
_run $XP_HTTP -run || rm -f $XP_HTTP
_xp_date=`date +%Y%m%d`; set +x
if [[ $_xp_date != ${xp_date:-0} ]]; then
	rm -f $INI/xp_http.ini
	echo "xp_date=$_xp_date\nunset package name summary author uploaded version code download md5sum size\ncase \$@ in" >$XP_HTTP
	toast ">>>正在加载Xposed模块仓库<<<"
	curl -s --connect-timeout 10 ${URL_DEV}https://dl-xda.xposed.info/repo/full.xml.gz | gunzip | sed -n '/<module/p; /    <name>/p; /<summary>/p; /<author>/p; /<code>/p; /<download>/p; /<md5sum>/p; /<size>/p; /<\/version>/p; /<\/module>/p' | sed 's/  //g; s/">$/"/g; s/.*package="/package="/g; s/ created=".*updated="/\nupdated="/g; s/<name>/name="/g; s/<\/name>/"/g; s/<summary>/summary="/g; s/<\/summary>/"/g; s/<author>/author="/g; s/<\/author>/"/g; s/<code>/code="/g; s/<\/code>/"/g; s/<download>/download="/g; s/<\/download>/"/g; s/<md5sum>/md5sum="/g; s/<\/md5sum>/"/g; s/<size>/size="/g; s/<\/size>/"/g; ' | while read i; do
		case "$i" in
		package=*)
		p="$i"
		echo "${i/*=})\n$i" >>$XP_HTTP
		;;
		updated=*)
		echo "$i" >>$XP_HTTP
		echo "${i/*=} ${p/*=}" >>$INI/xp_http.ini
		unset p
		;;
		name=*)
		if [[ -z $n ]]; then
			n=0; echo "name='`xml_cat "${i/name=}"`'" >>$XP_HTTP
		else
			((ii++)); echo "\n${i/name=/version[$ii]=}" >>$XP_HTTP
		fi
		;;
		summary=*)
		echo "summary='`xml_cat "${i/summary=/}"`'" >>$XP_HTTP
		;;
		code=*)
		echo "${i/code=/code[$ii]=}" >>$XP_HTTP
		;;
		download=*)
		echo "${i/download=/download[$ii]=}" >>$XP_HTTP
		;;
		md5sum=*)
		echo "${i/md5sum=/md5sum[$ii]=}" >>$XP_HTTP
		;;
		size=*)
		echo "${i/size=/size[$ii]=}" >>$XP_HTTP
		;;
		*'version>')
		v=0
		;;
		'</module>')
		unset v n; ii=0
		echo ';;&\n' >>$XP_HTTP
		;;
		*) echo "$i" >>$XP_HTTP;;
		esac
	done
	sort -rno $INI/xp_http.ini $INI/xp_http.ini
	echo "-sj)\ncat <<-CCAEO\n$(cat $INI/xp_http.ini | cut -d' ' -f2)\nCCAEO\n;;\n" >>$XP_HTTP
	echo '-run) return 0;;\n*) return $$;;\nesac' >>$XP_HTTP
else
	if [[ `wc -c <$XML/http_xp.XML` -le 500 ]]; then
		return 0
	else
		return $$
	fi
fi
}
xp_git() {
S_T; trap 'E_T -t 加载Xposed模块仓库' EXIT
xp_http || return $$
exec 1>$XML/http_xp.XML
cxml
_run $XP_HTTP -run
cat <<-CCAEO
<group>
	<action title="刷新仓库" confirm="true" reload="true" auto-off="true" >
		<set>rm -f \$XP_HTTP</set>
		<desc>- 刷新时间：$xp_date</desc>
		<summary>可点击确定即可刷新，默认每天只刷新一次</summary>
	</action>
</group>
CCAEO
xp_cat() {
unset n _vn _vc _version _summary
if [[ -e $DA_DIR/$package ]]; then
	_vn=`app_vn $package`
	_vc=`app_vc $package`
	_summary="- 当前版本：$_vn（$_vc）&#x000A;"
fi
for i in ${version[@]}; do
	((n++))
	_version="$_version\n${download[$n]}::${size[$n]}::${md5sum[$n]}|$n、$i"
done
cat <<-CCAEO
<action title="$name" >
	<set>xp_all</set>
	<summary>$_summary- 上传时间：`_time @$updated`</summary>
	<desc>包名：$package&#x000A;作者：${author:-未提供}&#x000A;版本：${version[1]}（${code[1]}），历史版本共$n个&#x000A;说明：${summary:-未提供}</desc>
	<params>
		<param name="xp_c" title="应用说明" value="$summary" />
		<param name="xp_a" label="下载版本" options-sh="echo '$_version'" />
		<param name="xp_b" label="操作选项" options-sh="echo '1|下载安装\n2|仅下载\n3|打开链接'" />
		<param name="_rm" label="下载安装后删除文件" type="switch" />
		<param name="_js" label="使用CDN加速下载" type="switch" value="$cdn" />
	</params>
</action>
CCAEO
}
if [[ `du $XP_HTTP | cut -f 1` -le 4 ]]; then
	toast ">>>加载Xposed模块仓库失败<<<"
	txml -g -s 25 '加载失败，可点击刷新仓库'
	return $$
fi
toast "<<<正在解析Xposed模块仓库>>>"
echo '<group>'
for i in `. $XP_HTTP -sj | sed 's/"//g'`; do
	if [[ -d $DA_DIR/$i ]]; then
		. $XP_HTTP $i
		((h++))
		http_xp[$h]=$i
		if [[ ${code[1]} -gt `app_vc $i` ]]; then
			if [[ -z $f ]]; then
				f=0
				txml -s 25 '模块有更新（AAA）'
			fi
			xp_cat
			((AAA++))
		fi
	else
		((p++))
		xp_http[$p]=$i
	fi
done
echo '</group>\n<group>'
for i in ${http_xp[@]}; do
	. $XP_HTTP $i
	if [[ -z $l ]]; then
		l=0
		txml -s 25 '模块已安装（AXP）'
	fi
	xp_cat
	((AXP++))
done
echo '</group>\n<group>'
_fifo="$APP_TMP/$$"
_num=`_free`
toast "- 使用	$_num	条线程加载"
mkfifo "$_fifo"
exec 6<>"$_fifo"
rm -f "$_fifo"
for i in ${xp_http[@]}; do
	((n++))
	j="$j\n$i"
	if [[ $n -ge $_num ]]; then
		if [[ -z $x ]]; then
			x=0
			txml -s 25 '模块未安装（XPA）'
		fi
		for o in `seq "$_num"`; do
			echo
		done >&6
		for i in `echo "$j"`; do
			read -u6
			((XPA++))
			{
				. $XP_HTTP $i
				xp_cat
				echo>&6
			}&
		done
		wait
		unset n j
		for w in `seq $_num`; do
			read -u6
		done
	fi
done
exec 6>&-
exec 6<&-
echo '</group>'
sed -i "s/AAA/$AAA/" $XML/http_xp.XML
sed -i "s/AXP/$AXP/" $XML/http_xp.XML
sed -i "s/XPA/$XPA/" $XML/http_xp.XML
}
lsp_http() {
_run $LSP_HTTP -run || rm -f $LSP_HTTP
_lsp_date=`date +%Y%m%d`
if [[ $_lsp_date != ${lsp_date:-0} ]]
then echo "lsp_date=$_lsp_date\nunset _name description _description url homepageUrl collaborators releases updatedAt tagName releaseAssets _releaseAssets downloadUrl summary\ncase \$@ in" >$LSP_HTTP
	toast ">>>正在加载LSPosed模块仓库<<<"
	curl -s --connect-timeout 10 ${URL_DEV}https://modules.lsposed.org/modules.json | sed 's/,"/\n/g; s/},/\n/g; s/":/=/g; s/"}]/"\n}]/g; s/=\[{"name=/=/g; s/=\[{"login=/=/g; s/{"/\n_/g' | sed -n '/^_name="/p; /^description="/p; /^url="/p; /^homepageUrl="/p; /^collaborators="/p; /^releases="/p; /^updatedAt="/p; /^tagName="/p; /^releaseAssets="/p; /^downloadUrl="/p; /^summary="/p' | grep -v '/releases/tag/' | while read i
	do case "$i" in
		_name=*)
		if [[ -z $_n ]]
		then _n=0
			echo "${i/_name=/})\n$i" >>$LSP_HTTP
		else ((n++))
			echo "${i/_name=/releaseAssets[$n]=}" >>$LSP_HTTP
		fi
		;;
		description=*)
		if [[ -z $_d ]]
		then _d=0
			echo "$i" >>$LSP_HTTP
		else echo "_description='`xml_cat "${i/description=/}"`'" >>$LSP_HTTP
		fi
		;;
		downloadUrl=*)
		if [[ -z $_r ]]
		then _r=0
			echo "$i" >>$LSP_HTTP
		else echo "${i/downloadUrl=/downloadUrl[$n]=}" >>$LSP_HTTP
		fi
		;;
		summary=*)
		echo "summary='`xml_cat ${i/summary=/}`'" >>$LSP_HTTP
		;;
		updatedAt=*)
		if [[ -n $_u ]]
		then unset _u _n _d _r
			echo "$i\n;;\n" >>$LSP_HTTP
		else _u=0
		fi
		;;
		*) echo "$i" >>$LSP_HTTP;;
		esac
	done
	echo '-run) return 0;;\n*) return $$;;\nesac' >>$LSP_HTTP
else if [[ `wc -c <$XML/http_lsp.XML` -le 500 ]]
	then return 0
	else return $$
	fi
fi
}
lsp_git() {
S_T; trap 'E_T -t 加载LSPosed模块仓库' EXIT
lsp_http || return $$
exec 1>$XML/http_lsp.XML
cxml; _run $LSP_HTTP -run
cat <<-CCAEO
<group>
	<action title="刷新仓库" confirm="true" reload="true" auto-off="true" >
		<set>rm -f \$LSP_HTTP</set>
		<desc>- 刷新时间：$lsp_date</desc>
		<summary>可点击确定即可刷新，默认每天只刷新一次</summary>
	</action>
</group>
CCAEO
xp_cat() {
unset _vn _vc _summary
if [[ -e $DA_DIR/$_name ]]; then
	_vn=`app_vn $_name`
	_vc=`app_vc $_name`
	_summary="- 当前版本：$_vn（$_vc）&#x000A;"
fi
n=0; _releaseAssets=''
for i in ${releaseAssets[@]}; do
	_releaseAssets="$_releaseAssets\n${downloadUrl[$n]}::|$i"
	((n++))
done
cat <<-CCAEO
<action title="`xml_cat "$description"`" >
	<set>xp_all</set>
	<summary>$_summary- 上传时间：`_time -tz $updatedAt`</summary>
	<desc>包名：$_name&#x000A;作者：${collaborators:-未提供}&#x000A;版本：$releases（$tagName）&#x000A;说明：${summary:-未提供}</desc>
	<params>
		<param name="xp_c" title="更新日志" value="$_description" />
		<param name="xp_a" label="下载版本" options-sh="echo '$_releaseAssets'" />
		<param name="xp_b" label="操作选项" options-sh="echo '1|下载安装\n2|仅下载\n3|打开链接'" />
		<param name="_rm" label="下载安装后删除文件" type="switch" />
		<param name="_js" label="使用CDN加速下载" type="switch" value="$cdn" />
	</params>
</action>
CCAEO
}
if [[ `du $LSP_HTTP | cut -f 1` -le 4 ]]; then
	toast ">>>加载LSPosed模块仓库失败<<<"
	txml -g -s 25 '加载失败，可点击刷新仓库'
	return $$
fi
toast "<<<正在解析LSPosed模块仓库>>>"
echo '<group>'
for i in `sed -n 's/^_name=//p' $LSP_HTTP | sed 's/"//g'`
do if [[ -d $DA_DIR/$i ]]
	then . $LSP_HTTP $i
		((h++))
		http_lsp[$h]=$i
		if [[ $releases != *`app_vn $i`* ]]
		then if [[ -z $f ]]
			then f=0
				txml -s 25 '模块有更新（AAA）'
			fi
			xp_cat
			((AAA++))
		fi
	else ((p++))
		lsp_http[$p]=$i
	fi
done
echo '</group>\n<group>'
for i in ${http_lsp[@]}
do . $LSP_HTTP $i
	if [[ -z $l ]]
	then l=0
		txml -s 25 '模块已安装（ALSP）'
	fi
	xp_cat
	((ALSP++))
done
echo '</group>\n<group>'
for i in ${lsp_http[@]}
do . $LSP_HTTP $i
	if [[ -z $j ]]
	then j=0
		txml -s 25 '模块未安装（LSPA）'
	fi
	xp_cat
	((LSPA++))
done
echo '</group>'
sed -i "s/AAA/$AAA/" $XML/http_lsp.XML
sed -i "s/ALSP/$ALSP/" $XML/http_lsp.XML
sed -i "s/LSPA/$LSPA/" $XML/http_lsp.XML
}
gn_ph() {
_run $RUN/url.sh
_run $INI/theme.ini
cxml; cat <<-CCAEO
<group>
	<action title="目前版本" icon="`ls $SD_DIR/?ndroid/data/com.tencent.mobileqq/*/*/head/_SSOhd/*`" id="@vc" reload="@vc" confirm="true" >
		<set>CW_IP</set>
		<desc sh="echo '- 页面：$y&#x000A;- 软件：$APP_VC&#x000A;- 配置：$cv&#x000A;- 指令：$s&#x000A;- busybox：`cat \$INI/busybox.ini`'" />
	</action>
</group>
<group>
	<action title="全局CDN加速" desc="仅支持带有CDN加速下载的选项" id="@cdn" reload="@cdn" auto-off="true" >
		<set>[[ \$_js = 1 ]] &#38;&#38; touch \$INI/cdn.ini || rm -f \$INI/cdn.ini</set>
		<params>
			<param name="_js" label="使用CDN加速下载" type="switch" value="$cdn" />
		</params>
	</action>
	<action title="自定义主题颜色" desc="仅首次使用需要重启生效" id="@se" reload="@se" >
	<set>app_theme</set>
		<params>
			<param name="colorAccent" label="全局颜色" value="${colorAccent:-#ff0f9d58}" type="color" />
			<param name="log_basic" label="日志颜色" value="${log_basic:-#ff9c27b0}" type="color" />
			<param name="log_error" label="错误颜色" value="${log_error:-#ffff0000}" type="color" />
			<param name="log_end" label="结束颜色" value="${log_end:-#ff1565c0}" type="color" />
			<param name="_se" label="使用默认颜色" type="switch" />
		</params>
	</action>
</group>
CCAEO
}
app_theme() {
TMP=$TMP/$APP_NA
mod=$MOD_DIR/$APP_NA.theme
S=system/media/theme/default
T=$mod/$S
MK $TMP/nightmode $T
xml=$TMP/nightmode/theme_values.xml
[[ $_se = 1 ]] && unset colorAccent log_basic log_error log_end
se() {
cat <<-CCAEO >>$xml
<color name="$1">$2</color>$3
CCAEO
}
cat <<-CCAEO >$xml
<?xml version="1.0" encoding="utf-8"?>
<MIUI_Theme_Values>
CCAEO
cat<<-CCAEO >$INI/theme.ini
colorAccent=${colorAccent:-#ff0f9d58}
log_basic=${log_basic:-#ff9c27b0}
log_error=${log_error:-#ffff0000}
log_end=${log_end:-#ff1565c0}
CCAEO
. $INI/theme.ini
se colorAccent $colorAccent 软件全局颜色
se kr_shell_log_basic $log_basic 脚本日志颜色
se kr_shell_log_error $log_error 脚本执行错误颜色
se kr_shell_log_end $log_end 脚本运行结束颜色
echo '</MIUI_Theme_Values>' >>$xml
cp $xml $TMP
echo "- 正在打包"
cd $TMP
7za a -tzip $TMP.zip ./* 1>/dev/null
mv -f $TMP.zip $T/$APP_NA
rm -rf $TMP
cat<<-CCAEO >$mod/module.prop
id=${mod##*/}
author=$APP_BY
name=$APP_NA自定义主题颜色
version=`date '+%Y年%m月%d日·%H点%M分%S秒'`
versionCode=$$
description=软件全局颜色	$colorAccent，脚本日志颜色	$log_basic，脚本执行错误颜色	$log_error，脚本运行结束颜色	$log_end。
CCAEO
if [[ -f $mod/module.prop && -f $S/$APP_NA ]]
then cp -fp $T/$APP_NA /$S
	am force-stop $APP_NA && am start -S $APP_NA/com.projectkr.shell.SplashActivity
else touch $mod/update
	echo "- 重启后生效"
fi
}
xp_all() {
[[ -z $xp_a ]] && abort "未选择版本"
if [[ $xp_b = 3 ]]
then web_url "$xp_a"
fi
set -- ${xp_a//::/ }
[[ $_js = 1 ]] && js=$APP_DEV
[[ $_rm = 1 ]] && Rm='-r'
_dir=$APP_DOWN/xp; MK $_dir
if XZ -# $js$1 "$_dir/${1##*/}" $2 $3
then if [[ $xp_b = 2 ]]
	then echo "已下载到	$_dir/${1##*/}"
	else axm_all $Rm "$_dir/${1##*/}"
	fi
fi
}
app_xp() {
if [[ $# = 0 ]]
then appinfo -sort-i -ed \" -d =\" -o pn_,an -xm -d _vn=\" -o pn_,vn -xm -d _vc=\" -o pn_,vc -xm -d _dir=\" -o pn_,path -xm
else appinfo -sort-i -o pn -xm
fi
}
ddw() {
if [[ -n $package2 ]]
then for i in ${package2//,/ }
	do dumpsys deviceidle whitelist -"$i" | sed 's/^Removed: /- 黑名单添加：/g'
	done
fi
if [[ -n $package ]]
then for i in ${package//,/ }
	do dumpsys deviceidle whitelist +"$i" | sed 's/^Added: /- 白名单添加：/g'
	done
fi
}
git_cat() {
cat <<-CCAEO >$APP_DOWN/git_release.ini
$git_xml
CCAEO
[[ $_git = 1 ]] && echo "$git_http" >$APP_DOWN/git_release.ini
}
git_xml() {
S_T; trap 'E_T -t 加载Release' EXIT; cxml
txml -g '获取失败原因（可能）：&#x000A;1、连接超过10秒为超时。2、没有获取到Release。3、链接输入错误？'
cat <<-CCAEO
<group>
	<action title="获取链接	Release" reload="true" auto-off="true" >
		<set>git_cat</set>
		<params>
			<param name="git_http" label="已收集有" multiple="multiple" options-sh="git_http" />
			<param name="_git" label="使用收集？" type="switch" />
			<param name="git_xml" title="请输入" desc="后面的	releases	可以不加" placeholder="例：https://github.com/LSPosed/LSPosed/releases" value-sh="cat \$APP_DOWN/git_release.ini" />
		</params>
	</action>
</group>
CCAEO
for i in `cat $APP_DOWN/git_release.ini | fgrep -v '#'`
do git_api "$i"
done
}
git_url() {
cat <<CCAEO
0|不使用
1|hub.fastgit.org
2|huge.cf
3|url.ccaeo.workers.dev
CCAEO
}
git_http() {
cat <<CCAEO
https://github.com/LSPosed/LSPosed|LSPosed
https://github.com/NekoX-Dev/NekoX|NekoX（TG猫报）
https://github.com/Kr328/ClashForAndroid|Clash（小猫咪）
https://github.com/Dr-TSNG/Hide-My-Applist|隐藏应用列表
https://github.com/gedoor/legado|阅读3.0
https://github.com/Tornaco/Thanox|Thanox（灭霸）
https://github.com/nining377/dolby_beta|杜比大喇叭β版
https://github.com/KyuubiRan/QQCleaner|瘦身模块
CCAEO
}
git_api() {
_api() { curl -s --connect-timeout 10 "https://api.github.com/repos/$@/releases/latest" | egrep 'tag_name|updated_at|size|browser_download_url|body' | sed 's/.*  "//g; s/": /=/g; s/,$//g'; }
[[ $# = 0 ]] && return $$; n=0
release=`echo "$@" | cut -d'/' -f4,5`
toast "获取	$release"
release="`_api $release`"
if [[ -z $release ]]; then
	toast "$release	失败"
	txml -g "获取	${1##*/}	失败"
	return $$
fi
eval "$release"
cat <<-CCAEO
<group>
	<action title="${1##*/}" >
		<set>git_xz \$releases</set>
		<params>
			<param name="body" title="版本日志" value="`xml_cat "${body:-无日志}"`" />
			<param name="releases" label="Release" >
CCAEO
for i in `echo "$release" | egrep -v 'tag_name|updated_at'`
do if [[ "$i" = browser_download_url* ]]
	then eval "$i $a"
		((n++))
		cat <<-CCAEO
				<option value="$browser_download_url $size">$n、${browser_download_url##*/}</option>
		CCAEO
		unset a size browser_download_url
	else
		a="$i"
	fi
done
cat <<-CCAEO
			</param>
			<param name="xz" label="选项" title="注意：下载安装仅支持	APK	和	Magisk	模块" options-sh="echo '1|下载安装\n2|仅下载'" />
			<param name="_rm" label="下载安装后删除文件" type="switch" />
			<param name="_js" label="使用CDN加速下载" type="switch" value="$cdn" />
		</params>
		<desc>最新版本：$tag_name·共有：$n个</desc>
		<summary>- 上传时间：`_time -tz $updated_at`</summary>
	</action>
</group>
CCAEO
}
git_xz() {
[[ -z "$1" ]] && abort "未选择	Release"
if [[ "${1##*/}" = *.apk  ]]
then _dir=$APP_DOWN/apk; MK $_dir
elif [[ "${1##*/}" = *.zip ]]
then _dir=$APP_DOWN/zip; MK $_dir
fi
[[ $_js = 1 ]] && js=$APP_DEV
[[ $_rm = 1 ]] && Rm='-r'
if XZ "$js$1" "$_dir/${1##*/}" "$2"
then [[ $xz = 2 ]] && return 0
	axm_all $Rm "$_dir/${1##*/}"
fi
}
xp_lsp() {
mod=$APP_DOWN/mod
MK $mod
if [[ $riru != 1 ]]
then . $SH_DOWN riru -down $mod
	echo "- 已下载到	$mod/$_dir"
	mod_all_zip "$mod/$_dir"
fi
. $SH_DOWN lsposed -down $mod
echo "- 已下载到	$mod/$_dir"
mod_all_zip "$mod/$_dir"
}
auto_run() {
cxml; cat <<-CCAEO
<group>
	<action title="一键安装	LSPosed" reload="true" >
		<set>xp_lsp</set>
		<desc>一键安装/升级	Riru（可选）、LSPosed框架</desc>
		<params>
			<param name="riru" label="不安装	Riru" type="switch" />
		</params>
	</action>
</group>
CCAEO
}
axm_all() {
[[ $1 = -r ]] && shift && _r="$1"
echo "progress:[-1/0]"
if [[ "$1" = *.zip ]]
then mod_all_zip "$1"
else unzip -l "$1" | fgrep -q 'AndroidManifest.xml' || abort "不是	APK	应用"
	echo ${axm_:-com.android.vending} >$INI/axm.ini
	ii=`cat $INI/axm.ini`
	ss=`wc -c < "$1"`
	echo "- 正在以	$ii 安装应用	${1##*/}\n- 文件路径	$1"
	a="cat \""$1"\" | pm install -r -S "$ss" -i 'com.android.vending' 1>/dev/null"
	eval "$a"; ex=$?
	if [[ $ex != 0 ]]
	then error "安装	${1##*/}	失败，二次安装"
		lo="/data/local/tmp/${1##*/}"
		cp -f "$1" "$lo"
		a="pm install -r -i 'com.android.vending' \""/data/local/tmp/${1##*/}"\" 1>/dev/null"
		eval "$a"; ex=$?
		rm -f "$lo"
		[[ $ex = 0 ]] || abort "二次安装	${1##*/}	失败"
	fi
	if [[ -f "$_r" ]]
	then rm -f "$_r"
		error "- 已删除	$_r"
		return $ex
	fi
fi
}
axm_xz() {
apk_dir=$APP_DOWN/axm
MK $apk_dir
if . $SH_DOWN "$@" -down $apk_dir
then echo "- 已下载到	$apk_dir/$_dir"
else return $$
fi
[[ $_axm = 2 ]] && return 0
[[ $_rm = 1 ]] && Rm='-r'
axm_all $Rm "$apk_dir/$_dir"
}
axm_uzji() {
S_T; trap 'E_T -t 加载收集' EXIT; cxml
[[ -s $INI/axm.ini ]] && echo 'com.android.vending' >$INI/axm.ini
txml -a -s 25 '均为手动收集'
if [[ $1 = _app ]]
then cat <<-CCAEO
<group>
	<page title="Magisk模块收集" config-sh="axm_uzji _mod" >
		<handler>CQ</handler>
		<menu type="refresh">刷新界面</menu>
		<menu type="exit">关闭页面</menu>
		<option type="default" id="1">重启手机</option>
	</page>
	<page title="Xposed模块收集" config-sh="axm_uzji _xp" >
		<handler>CQ</handler>
		<menu type="refresh">刷新界面</menu>
		<menu type="exit">关闭页面</menu>
		<option type="default" id="1">重启手机</option>
	</page>
</group>
CCAEO
fi
for i in `sed -n "s/^$1=//p" $SH_DOWN`
do ((n++)); . $SH_DOWN $i || return $$
[[ -z $_url ]] && return $$
unset _summary
if [[ -e $DA_DIR/${_id:-$i} ]]; then
	_vn=`app_vn ${_id:-$i}`
	_vc=`app_vc ${_id:-$i}`
	_summary="- 当前版本：$_vn（$_vc）&#x000A;"
elif [[ -e $MOD_DIR/${_id:-$i} ]]; then
	_mod $MOD_DIR/${_id:-$i}
	_summary="- 当前版本：$mod_vn（$mod_vc）&#x000A;"
fi
cat <<-CCAEO
<group title="$n" >
	<action title="$_name" id="@$_md5" reload="@$_md5" >
		<set>axm_xz &#34;$_id&#34;</set>
		<desc>收集id：${_id:-$i}&#x000A;作者：${_author:-未提供}&#x000A;版本：$_version&#x000A;版本号：$_versionCode&#x000A;文件大小：`_size $_size`&#x000A;描述说明：${_desc:-未提供}</desc>
		<summary>$_summary- 上传时间：`_time @$_date`</summary>
		<params>
			<param name="_axm" label="选项" options-sh="echo '1|下载安装\n2|仅下载'" />
			<param name="_rm" label="下载安装后删除文件" type="switch" />
			<param name="axm_" title="自定义安装来源" desc="默认安装来源：com.android.vending" placeholder="com.android.vending" value-sh="cat \$INI/axm.ini" />
		</params>
	</action>
</group>
CCAEO
done
}
html_http() {
cxml; cat <<-CCAEO
<group title="蓝奏云" >
	<page title="Autosync Ultimate版" desc="密码：5uvg" summary="by 酷安@1720921" link="https://saiting.lanzoui.com/b0107xh8h" />
	<page title="阅读3.0测试版" summary="by TG@legado_channels" link="https://kunfei.lanzoux.com/b0f810h4b" />
	<page title="皮皮虾历史版本" summary="by 酷安@1806534" link="https://pipix.lanzoui.com/b02mul3yd" />
	<page title="MIUI主题破解" summary="by 酷安@680367" link="https://lanzoux.com/b00ty1pej" />
</group>
<group title="文叔叔" >
	<page title="照片编辑器无广告版" summary="by 酷安@201225" link="https://www.wenshushu.cn/box/3z7nl7mey08/folder/3zoptq7gory" />
</group>
<group title="Gitee" >
	<page title="Termux运行GNU/Linux" link="https://gitee.com/mo2/linux" />
	<page title="蓝奏云下载地址解析API" link="https://gitee.com/web/lanzou" />
</group>
<group title="GitHub" >
	<page title="NekoX（TG猫报）" link="https://github.com/NekoX-Dev/NekoX" />
	<page title="GitHub520" link="https://raw.hellogithub.com/hosts" />
	<page title="Clash（小猫咪）" link="https://github.com/Kr328/ClashForAndroid" />
	<page title="Cross-Compiled-Binaries-Android" link="https://github.com/Zackptg5/Cross-Compiled-Binaries-Android" />
	<page title="AnXray（AX）" link="https://github.com/XTLS/AnXray" />
	<page title="v2rayNG（V2）" link="https://github.com/2dust/v2rayNG" />
	<page title="UpgradeAll" link="https://github.com/DUpdateSystem/UpgradeAll" />
	<page title="SagerNet（SN）" link="https://github.com/SagerNet/SagerNet" />
</group>
<group title="其他" >
	<page title="酷狗音乐内测版" link="https://kugou.fun/" />
	<page title="异星软件空间" link="https://www.yxssp.com/" />
	<page title="平平免费API" link="https://api.pingping6.com/" />
</group>
CCAEO
}
rom_kg() {
cxml; cat <<-CCAEO
<group>
	<switch confirm="true" shell="hidden">
		<title>极致模式</title>
		<get>gn_kg 1</get>
		<set>gn_kg 1</set>
	</switch>
	<switch confirm="true" shell="hidden">
		<title>网速模式</title>
		<get>gn_kg 2</get>
		<set>gn_kg 2</set>
	</switch>
	<switch confirm="true" shell="hidden">
		<title>极速模式</title>
		<get>gn_kg 3</get>
		<set>gn_kg 3</set>
	</switch>
	<switch confirm="true" shell="hidden">
		<title>内存扩展</title>
		<desc>重启生效</desc>
		<get>gn_kg 4</get>
		<set>gn_kg 4</set>
	</switch>
	<switch confirm="true" shell="hidden">
		<title>随机分配MAC地址</title>
		<get>gn_kg 5</get>
		<set>gn_kg 5</set>
	</switch>
</group>
CCAEO
}
gn_kg() {
if [[ -n $state ]]
then _state=true
else _state=false
fi
case "$1" in
0) settings put system min_refresh_rate 90
settings put system peak_refresh_rate 90
;;
1) settings get system speed_mode
$_state && settings put system speed_mode $state
;;
2) settings get system user_network_priority_enabled
$_state && settings put system user_network_priority_enabled $state
;;
3) settings get global mobile_tc_user_enable
$_state && settings put global mobile_tc_user_enable $state
;;
4) getprop persist.miui.extm.enable
$_state && setprop persist.miui.extm.enable $state
;;
5) settings get global enhanced_mac_randomization_force_enabled
$_state && settings put global enhanced_mac_randomization_force_enabled $state
;;
*) return $$;;
esac
}
fu_jgn() {
cxml; cat <<-CCAEO
<group title="界面" >
	<page title="自定义界面" desc="需要自写	xml" config-sh="zdy_xml" >
		<handler>CQ</handler>
		<menu type="refresh">刷新界面</menu>
		<menu type="exit">关闭页面</menu>
		<option type="default" id="1">重启手机</option>
		<lock>
			if [[ -f $XML/zdy.xml ]]; then
				echo 'unlocked'
			else
				echo "请在	$XML	创建	zdy.xml	文件"
			fi
		</lock>
	</page>
	<page title="网址收集" config-sh="html_http" >
		<handler>CQ</handler>
		<menu type="refresh">刷新界面</menu>
		<menu type="exit">关闭页面</menu>
		<option type="default" id="1">重启手机</option>
	</page>
	<page title="一键操作" config-sh="auto_run" >
		<handler>CQ</handler>
		<menu type="refresh">刷新界面</menu>
		<menu type="exit">关闭页面</menu>
		<option type="default" id="1">重启手机</option>
	</page>
	<page title="部分开关" desc="加载可能缓慢" config-sh="rom_kg" >
		<handler>CQ</handler>
		<menu type="refresh">刷新界面</menu>
		<menu type="exit">关闭页面</menu>
		<option type="default" id="1">重启手机</option>
	</page>
	<page title="ROM校验及刷入" config-sh="rom_zip" >
		<handler>CQ</handler>
		<menu type="refresh">刷新界面</menu>
		<menu type="exit">关闭页面</menu>
		<option type="default" id="1">重启手机</option>
	</page>
	<page title="ROM地址获取" config-sh="miui_rom" visible="[[ -f $DA_DIR/com.android.updater/shared_prefs/version_json.xml ]] &#38;&#38; echo 1 || echo 0" >
		<handler>CQ</handler>
		<menu type="refresh">刷新界面</menu>
		<menu type="exit">关闭页面</menu>
		<option type="default" id="1">重启手机</option>
	</page>
</group>
<group title="弹窗" >
	<action title="私人DNS" id="@dns" reload="@dns" >
		<set>dns_cat -n</set>
		<params>
			<param name="g" label="DNS开关" type="switch" value-sh="settings get global private_dns_mode | grep -c 'hostname'" />
			<param name="dns" label="已收集" options-sh="dns_cat" />
			<param name="_dns" title="自定义设置DNS" value-sh="settings get global private_dns_specifier | grep -iv 'null'" />
		</params>
	</action>
	<action title="动画缩放" id="@pwta" reload="@pwta" >
		<set>so_fh</set>
		<params>
			<param name="p" label="极致动画缩放0.01" type="bool" />
			<param name="w" label="窗口动画" required="true" value-sh="settings get global window_animation_scale" />
			<param name="t" label="过渡动画" required="true" value-sh="settings get global transition_animation_scale" />
			<param name="a" label="动画时长" required="true" value-sh="settings get global animator_duration_scale" />
		</params>
	</action>
	<action title="yc调度模式切换" id="@yc" reload="@yc" auto-off="true" visible="[[ -d \$MOD_DIR/uperf/script ]] &#38;&#38; echo 1 || echo 0" >
		<set>yc_sh -e</set>
		<params>
			<param name="_yc" label="模式" desc="部分版本无法切换极速模式" options-sh="echo 'powersave|省电模式\nbalance|均衡模式\nperformance|性能模式\nfast|极速模式'" value-sh="yc_sh -g" />
			<param name="yc" readonly="true" value-sh="yc_sh -s" />
		</params>
	</action>
	<action title="电池优化黑白名单" id="@dc" reload="@dc" >
		<params>
			<param name="package2" label="黑名单" desc="部分应用不支持黑名单" separator="," type="app" multiple="multiple" options-sh="dumpsys deviceidle whitelist | cut -d',' -f2" />
			<param name="package" label="白名单" separator="," type="app" multiple="multiple" options-sh="pm list package | cut -d':' -f2" />
		</params>
		<set>ddw</set>
	</action>
	<action title="MIUI步数增加" id="@buuu" reload="@buuu" >
		<params>
			<param name="buuu" title="滑动选择步数" type="seekbar" min="1" max="99999" value="10000" />
			<param name="_buuu" title="自定义步数" desc="一次性修改过多可能会封号" placeholder="请输入 1～99999 的步数" />
		</params>
		<set>buuu</set>
	</action>
	<action title="HttpCanary证书" id="@hc" reload="@hc" visible="[[ -d \$DA_DIR/com.guoshi.httpcanary.premium ]] &#38;&#38; echo 1 || echo 0" >
		<params>
			<param name="_hc" label="操作" options-sh="echo '1|安装\n2|移除'" />
		</params>
		<set>hc_ca</set>
	</action>
</group>
CCAEO
}
hc_ca() {
mod=$MOD_DIR/ccaeo_hc
hc=$DA_DIR/com.guoshi.httpcanary.premium/cache/HttpCanary.pem
if [[ $_hc = 2 ]]
then touch $mod/remove
	rm -f ${hc%/*}/HttpCanary.jks
	echo "- 重启后移除"
else if [[ -f $hc ]]
	then ca=`openssl x509 -inform PEM -subject_hash_old -in $hc | head -n 1`.0
		MK $mod $mod/system/etc/security/cacerts
		cat<<-CCAEO >$mod/module.prop
		id=ccaeo_hc
		author=$APP_BY
		name=HttpCanary证书
		version=`date '+%Y年%m月%d日·%H点%M分%S秒'`
		versionCode=$$
		description=将HttpCanary证书安装到/system/etc/security/cacerts/$ca
		CCAEO
		cp -af $hc $mod/system/etc/security/cacerts/$ca
		touch ${hc%/*}/HttpCanary.jks
		touch $mod/update
		echo "- 重启后生效"
	else abort "未发现	HttpCanary.pem"
	fi
fi
}
miui_rom() {
cxml; ROM_PROP
eval "$(sed -n '/current_version/p' $DA_DIR/com.android.updater/shared_prefs/version_json.xml | sed -e 's/&quot;:/=/g' -e 's/,&quot;METAHASH/"`\n/g' -e 's/,&quot;/\n/g' -e 's/&quot;/"/g' -e 's/{"/`echo "/g' | sed -n '/type=/p; /^device=/p; /^name=/p; /^md5=/p; /^codebase=/p; /^filename=/p; /^filesize=/p; /^FILESIZE=/p')"
txml -a -g -s 25 "$NAME（$DEVICE）&#x000A;`file_time $DA_DIR/com.android.updater/shared_prefs/version_json.xml`"
_rom() {
if [[ -n $md5 ]]
then cat <<-CCAEO
<group>
`txml -s 15 "$1包"`
	<action title="$name" id="@$md5" reload="@$md5" >
		<set>rom_miui &#34;$version&#34; &#34;$filename&#34;</set>
		<desc>代号：$device&#x000A;安卓：$codebase&#x000A;大小：$filesize&#x000A;估计：`_size $FILESIZE`&#x000A;MD5：$md5</desc>
		<params>
			<param name="jk_url" label="下载接口" options-sh="echo 'hu|hugeota.d\nbi|bigota.d'" />
			<param name="lj_url" label="操作选项" option-sh="echo '1|获取链接\n2|跳转下载'" />
		</params>
	</action>
</group>
CCAEO
fi
unset type device name md5 codebase filename filesize version FILESIZE
}
eval "$CurrentRom"
_rom '目前'
eval "$LatestRom"
_rom '升级'
eval "$IncrementRom"
_rom 'OTG'
eval "$CrossRom"
_rom '稳定'
eval "$(sed -n '/new_version/p' $DA_DIR/com.android.updater/shared_prefs/version_json.xml | sed -e 's/&quot;:/=/g' -e 's/,&quot;/\n/g' -e 's/&quot;/"/g' -e 's/{"/\n/g' | sed -n '/type=/p; /^device=/p; /^name=/p; /^md5=/p; /^codebase=/p; /^filename=/p; /^filesize=/p; /^FILESIZE=/p')"
_rom '稳定'
}
rom_miui() {
url="https://${jk_url}geota.d.miui.com"
if [[ $jk_url = hu ]]
then url="$url/$1/$2"
elif [[ $jk_url = bi ]]
then url="$url/$1/$2"
fi
if [[ $lj_url = 1 ]]
then echo "$url"
else web_url "$url"
fi
}
buuu() {
buuu=${_buuu:-$buuu}
if [[ $buuu != [0-9]* ]]
then abort "输入的步数	$buuu	不是数字"
elif [[ $buuu -gt 99999 ]]
then abort "输入的步数	$buuu	已超过 99999"
fi
echo "正在增加步数	$buuu"
content insert \
--uri content://com.miui.providers.steps/item \
--bind _begin_time:s:`date +%s%3N` \
--bind _id:i:$RANDOM \
--bind _end_time:s:`date +%s%3N` \
--bind _mode:i:2 \
--bind _steps:i:$buuu
return $?
}
yc_sh() {
case "$1" in
-e) /data/powercfg.sh "$_yc";;
-g) a=`cat $SD_DIR/yc/uperf/cur_powermode`
if [[ $a = powersave ]]
then echo "$a"
elif [[ $a = balance ]]
then echo "$a"
elif [[ $a = performance ]]
then echo "$a"
elif [[ $a = fast ]]
then echo "$a"
fi
;;
-s) a=`cat $SD_DIR/yc/uperf/cur_powermode`
if [[ $a = powersave ]]
then echo "- 当前省电模式"
elif [[ $a = balance ]]
then echo "- 当前均衡模式"
elif [[ $a = performance ]]
then echo "- 当前性能模式"
elif [[ $a = fast ]]
then echo "- 当前极速模式"
fi
;;
esac
}
so_fh() {
[[ $p = 1 ]] && w=0.01 && t=0.01 && a=0.01
[[ -n $w ]] && settings put global window_animation_scale "$w" && echo "- 修改窗口动画缩放	$w"
[[ -n $t ]] && settings put global transition_animation_scale "$t" && echo "- 修改过渡动画缩放	$t"
[[ -n $a ]] && settings put global animator_duration_scale "$a" && echo "- 修改动画时长缩放	$a"
}
dns_cat () {
dns="${_dns:-$dns}"
if [[ $1 = -n ]]
then [[ -z $dns ]] && abort "未选择或未输入"
	[[ $g = 0 ]] && settings put global private_dns_mode 'off' && abort "已关闭	DNS"
	if ping -c 5 -A -w 1 "$dns" 1>&2
	then
		settings put global private_dns_mode 'hostname'
		settings put global private_dns_specifier "$dns" && echo "- 已将	DNS	设置为	$dns" || abort "DNS	设置失败"
		return 0
	else
		abort "连接	$dns	失败"
	fi
fi
cat <<-CCAEO
dns.alidns.com|阿里DNS
dot.360.cn|360安全DNS
dns.pub|DNSPod DNS（腾讯DNS）
dns.twnic.tw|TWNIC Quad 101
one.one.one.one|Cloudflare DNS（泛播-Cloudflare）
1dot1dot1dot1.cloudflare-dns.com|Cloudflare DNS（泛播-Cloudflare）
family-filter-dns.cleanbrowsing.org|CleanBrowsing（家庭过滤器）
adult-filter-dns.cleanbrowsing.org|CleanBrowsing（成人过滤器）
security-filter-dns.cleanbrowsing.org|CleanBrowsing（‎安全过滤器‎‎）
dns.google|Google DNS
dns.adguard.com|Adguard DNS（“默认”服务器）
dns-family.adguard.com|Adguard DNS（“家庭保护”服务器）
dns-unfiltered.adguard.com|Adguard DNS（“非过滤”服务器）
dns.nextdns.io|NextDNS
public.dns.iij.jp|Internet Initiative Japan
dns.aa.net.uk|Andrews＆Arnold
doh.dnslify.com|DNSlify
private.canadianshield.cira.ca|Canadian Shield
doh.powerdns.org|PowerDNS
rdns.faelix.net|FAELIX
dns.digitale-gesellschaft.ch|Digitale Gesellschaft
CCAEO
}
w_n() {
error -n "- 网络状态	"
IP="`ip route`"
case "$IP" in
*wlan*) error "WiFi";;
*rmnet_data*) error "流量";;
*bt-pan*) error "蓝牙";;
*) error "未知";;
esac
#if dumpsys connectivity 2>/dev/null | egrep -qi 'type: wifi.*ssid'
#then error "WiFi"
#elif dumpsys connectivity 2>/dev/null | egrep -qi 'type: .*scuiot'
#then error "流量"
#fi
}
ccaeo_vc() {
_run $RUN/url.sh
A() {
[[ -e $APP_TMP/update ]] || echo "！未初始化加载配置\n，请前往主页重新加载"
if [[ `md5sum2 $CCAEO` != "$c" ]]
then echo "！配置已有更新，请加载"
fi
if [[ `md5sum2 "$(pm path $APP_NA | sed 's/package://g')"` != "$v" ]]
then echo "！软件已有更新，请加载"
fi
}
if $SOME; then
echo [
cat <<-CCAEO
{
	"Action": {
		"meta": {
			"confirm": true,
			"reload": true,
			"auto-off": false
		},
		"title": "当前版本",
		"desc": "- 页面：$y\n- 软件：$APP_VN（$APP_VC）",
		"summary": "可点击确定即可刷新，默认每天只刷新一次",
		"shell": "cq_jz"
	}
},
{
	"Text": {
		"value": "<font size=\"30\" color='`ff_ys`'>`A`</font>"
	}
},
CCAEO
else
cat <<-CCAEO
`cxml`
<group>
	<action title="当前版本" icon="`ls $APP_PATH/*.cache $SD_DIR/?ndroid/data/com.tencent.mobileqq/*/*/head/_SSOhd/*`" confirm="true" reload="true" auto-off="true" >
		<set>cq_jz</set>
		<desc>- 页面：$y&#x000A;- 软件：$APP_VN（$APP_VC）</desc>
		<summary>可点击确定即可刷新，默认每天只刷新一次</summary>
	</action>
</group>
<group>
	<text>
		<slices>
			<slice activity="$APP_AP" color="`ff_ys`" size="25">`A`</slice>
			<slice activity="$APP_AP" color="`ff_ys`" break="true" size="25">功能基于MIUI适配，其他机型可能无效</slice>
		</slices>
	</text>
</group>
CCAEO
fi
}
cq_jz() {
[[ -e $APP_TMP/update ]] || abort "未初始化加载配置"
rm -f $APP_TMP/date.log
_run $APP_PATH/run.sh
_run $RUN/url.sh
if [[ `md5sum2 "$(pm path $APP_NA | sed 's/package://g')"` != "$v" ]]
then error "- 软件更新"
	XZ -# $CODING/$APP_NA.apk $APP_DOWN/$APP_NA.apk $vs $v
	error "- 正在安装"
	sleep 5
	rm -rf $APP_PATH/*
	axm_all "$APP_DOWN/$APP_NA.apk" && am start -S $APP_NA/com.projectkr.shell.SplashActivity
	exit $?
fi
}
_‮() {
#文件加速
https://github.zhlh6.cn/
https://ghproxy.com/
https://gh.api.99988866.xyz/
https://shrill-pond-3e81.hunsh.workers.dev/
https://github.lx164.workers.dev/
#代下载
https://d.serctl.com/
https://ghproxy.com/
#GitHub镜像
##gitclone镜像
https://gitclone.com/
##阿里镜像
https://github.com.cnpmjs.org/

https://url.ccaeo.workers.dev/?url=
https://js.svvme.com/-----
https://js.link1.workers.dev/-----
https://raw.staticdn.net
https://ghproxy.com/

https://ip125.com/
http://ip111.cn/

ping -c 1 -A -w 1 | sed -n 's/.*= //p' | cut -d'/' -f2

am start "intent:#Intent;action=android.intent.action.VIEW;category=org.lsposed.manager.LAUNCH_MANAGER;package=com.android.shell;component=com.android.shell/.BugreportWarningActivity;end"

cat <<CCAEO | egrep -v '.*time.*=' &>./.02.ini
`settings list system`
---system?---

`settings list secure`
---secure?---

`settings list global`
---global?---

`getprop`
---getprop?---
CCAEO

开启5G网络模式选择：*#*#726633#*#*
进入神隐模式：*#*#76937#*#*
启用VoLTE高清通话：*#*#86583#*#*
启用SGVoNR高清通话：*#*#8667#*#*

openssl x509 -inform PEM -subject_hash_old -in $DA_DIR/com.guoshi.httpcanary.premium/cache/HttpCanary.pem | head -n 1

setsid ping -c 50 -w 4 -A -q $ip | sed -n 's/.*= //p' | awk '///{printf("%.f",$2)}'

_free=`free -m | awk '/-/{print $4}'`
if [[ $_free -ge 1000 ]]
then _free=${_free:0:2}
elif [[ $_free -le 1000 ]]
then _free=${_free:0:1}
fi

_fifo="$APP_TMP/$$"
let _num=${_num:-0}/10
[[ $_num -eq 0 ]] && _num=10
mkfifo "$_fifo"
exec 6<>"$_fifo"
rm -f "$_fifo"
for o in `seq "$_num"`
do echo
done >&6
for o in `seq "$_num"`
do read -u6
{
	echo $o
	echo >&6
}&
done
wait
for w in `seq $_num`
do read -u6
done
exec 6>&-
exec 6<&-
}
ff_ys() {
#by url：https://zhidao.baidu.com/question/491846211.html
cat <<CCAEO | sed -n 's/.*:://p' | sed -n $((RANDOM%98+1))p
红色::#FFFF0000
深紫色::#FF871F78
褐红色::#FF8E236B
石英色::#FFD9D9F3
绿色::#FF00FF00
深石板蓝::#FF6B238E
中海蓝色::#FF32CD99
艳蓝色::#FF5959AB
蓝色::#FF0000FF
深铅灰色::#FF2F4F4F
中蓝色::#FF3232CD
鲑鱼色::#FF6F4242
牡丹红::#FFFF00FF
深棕褐色::#FF97694F
中森林绿::#FF6B8E23
猩红色::#FFBC1717
青色::#FF00FFFF
深绿松石色::#FF7093DB
中鲜黄色::#FFEAEAAE
海绿色::#FF238E68
黄色::#FFFFFF00
暗木色::#FF855E42
中兰花色::#FF9370DB
半甜巧克力色::#FF6B4226
黑色::#FF000000
淡灰色::#FF545454
中海绿色::#FF426F42
赭色::#FF8E6B23
海蓝::#FF70DB93
土灰玫瑰红色::#FF856363
中石板蓝色::#FF7F00FF
银色::#FFE6E8FA
巧克力色::#FF5C3317
长石色::#FFD19275
中春绿色::#FF7FFF00
天蓝::#FF3299CC
蓝紫色::#FF9F5F9F
火砖色::#FF8E2323
中绿松石色::#FF70DBDB
石板蓝::#FF007FFF
黄铜色::#FFB5A642
森林绿::#FF238E23
中紫红色::#FFDB7093
艳粉红色::#FFFF1CAE
亮金色::#FFD9D919
金色::#FFCD7F32
中木色::#FFA68064
春绿色::#FF00FF7F
棕色::#FFA67D3D
鲜黄色::#FFDBDB70
深藏青色::#FF2F2F4F
钢蓝色::#FF236B8E
青铜色::#FF8C7853
灰色::#FFC0C0C0
海军蓝::#FF23238E
亮天蓝色::#FF38B0DE
2号青铜色::#FFA67D3D
铜绿色::#FF527F76
霓虹篮::#FF4D4DFF
棕褐色::#FFDB9370
士官服蓝色::#FF5F9F9F
青黄色::#FF93DB70
霓虹粉红::#FFFF6EC7
紫红色::#FFD8BFD8
冷铜色::#FFD98719
猎人绿::#FF215E21
新深藏青色::#FF00009C
石板蓝色::#FFADEAEA
铜色::#FFB87333
印度红::#FF4E2F2F
新棕褐色::#FFEBC79E
浓深棕色::#FF5C4033
珊瑚红::#FFFF7F00
土黄色::#FF9F9F5F
暗金黄色::#FFCFB53B
淡浅灰色::#FFCDCDCD
紫蓝色::#FF42426F
浅蓝色::#FFC0D9D9
橙色::#FFFF7F00
紫罗兰色::#FF4F2F4F
深棕::#FF5C4033
浅灰色::#FFA8A8A8
橙红色::#FFFF2400
紫罗兰红色::#FFCC3299
深绿::#FF2F4F2F
浅钢蓝色::#FF8F8FBD
淡紫色::#FFDB70DB
麦黄色::#FFD8D8BF
深铜绿色::#FF4A766E
浅木色::#FFE9C2A6
浅绿色::#FF8FBC8F
黄绿色::#FF99CC32
深橄榄绿::#FF4F4F2F
石灰绿色::#FF32CD32
粉红色::#FFBC8F8F
深兰花色::#FF9932CD
桔黄色::#FFE47833
李子色::#FFEAADEA
CCAEO
}
mod_http_all() {
ZIP=$TMP/run_shell/mod
MK $ZIP
mod_file="`echo "$2" | sed 's/ //g'`"
[[ $_js = 1 ]] && js=$APP_DEV
if [[ $mod_a = 1 || $mod_a = 2 ]]
then if XZ -# "$js$1" "$ZIP/$mod_file"
	then DIR=`7za x "$ZIP/$mod_file" -o$ZIP -y | egrep -v '/' | sed -n 's/Extracting  //p'`
		cd "$ZIP/$DIR"
		_u='./META-INF/com/google/android'
		fgrep -q '#MAGISK' $_u/updater-script || abort "不是	Magisk	模块"
		egrep -q '/util_functions.sh$' $_u/update-binary || {
		error "！正在添加	update-binary"
		cat <<-'CCAEO' >$_u/update-binary
			#!/sbin/sh
			umask 022
			ui_print() { echo "$1"; }
			require_new_magisk() {
				ui_print "*******************************"
				ui_print " 请安装 Magisk v20.4 以上的版本"
				ui_print "*******************************"
				exit 1
			}
			OUTFD=$2
			ZIPFILE=$3
			mount /data 2>/dev/null
			[ -f /data/adb/magisk/util_functions.sh ] || require_new_magisk
			. /data/adb/magisk/util_functions.sh
			[ $MAGISK_VER_CODE -lt 20400 ] && require_new_magisk
			install_module
			exit 0
		CCAEO
		}
		7za a -tzip "$APP_DOWN/mod/$mod_file.zip" ./* 1>/dev/null
		rm -rf $ZIP
		echo "- 已下载到	$APP_DOWN/mod/$mod_file.zip"
		[[ $mod_a = 2 ]] || mod_all_zip "$APP_DOWN/mod/$mod_file.zip"
	fi
elif [[ $mod_a = 3 ]]
then web_url "${1/archive*}"
else abort "未知错误	$mod_a｜$@"
fi
}
mod_http() {
_run $MOD_HTTP -run || rm -f $MOD_HTTP
_mod_date=`date +%Y%m%d`
if [[ $_mod_date != ${mod_date:-0} ]]
then echo "mod_date=$_mod_date\nunset id last_update prop_url zip_url notes_url\ncase \$@ in" >$MOD_HTTP
	toast ">>>正在加载Magisk模块仓库<<<"
	curl -s --connect-timeout 10 ${URL_DEV}https://magisk-modules-repo.github.io/submission/modules.json | sed -n '/id/,/notes_url/p' | sed 's/,//g; s/": /=/g; s/^      "//g' | while read i
	do case "$i" in
		id=*) echo "${i/id=/})\n$i" >>$MOD_HTTP;;
		notes_url=*) echo "$i\n;;\n" >>$MOD_HTTP;;
		*) echo "$i" >>$MOD_HTTP;;
		esac
	done
	echo '-run) return 0;;\n*) return $$;;\nesac' >>$MOD_HTTP
else if [[ `wc -c <$XML/http_mod.XML` -le 500 ]]
	then return 0
	else return $$
	fi
fi
}
test_xml() {
cxml
txml -a -g -s 50 '		开	发	中		'
exit $$
}
mod_git() {
S_T; trap 'E_T -t 加载Magisk模块仓库' EXIT
mod_http || return $$
exec 1>$XML/http_mod.XML
cxml; _run $MOD_HTTP -run
mod_id=($(sed -n 's/^id=//p' $MOD_HTTP | tr -d '"' ))
MK $TMP/prop
cat <<-CCAEO
<group>
	<action title="刷新仓库" confirm="true" reload="true" auto-off="true" >
		<set>rm -f \$MOD_HTTP</set>
		<desc>- 刷新时间：$mod_date</desc>
		<summary>可点击确定即可刷新，默认每天只刷新一次</summary>
	</action>
	<page title="Magisk模块仓库2" desc="只能加载出前	99	个模块" config-sh="mod_page" >
		<handler>mod_all_zip &#34;\$file&#34;</handler>
		<menu type="refresh">刷新界面</menu>
		<menu type="exit">关闭页面</menu>
		<option type="default" id="1">重启手机</option>
		<option type="file" suffix="zip">安装本地模块</option>
		<option type="file" style="fab" suffix="zip">安装本地模块</option>
	</page>
</group>
CCAEO
if [[ `du $MOD_HTTP | cut -f 1` -le 4 ]]
then toast ">>>加载Magisk模块仓库失败<<<"
	txml -g -s 25 '加载失败，可点击刷新仓库'
	return $$
fi
toast "<<<正在解析Magisk模块仓库>>>"
mod_xml() {
if [[ -n $description ]]; then
	_desc="模块id：$id&#x000A;作者：$author&#x000A;版本：$version&#x000A;版本号：$versionCode&#x000A;模块说明：$description"
	_mod $MOD_DIR/$id
	_summary="- 当前版本：$mod_vn（$mod_vc）&#x000A;"
else
	name="$id"
fi
cat <<-CCAEO
<action title="$name" id="@$id" reload="@yz,@,$id" >
	<set>mod_http_all &#34;$zip_url&#34; &#34;${id}_$version($versionCode)&#34;</set>
	<summary>$_summary- 获取时间：${mod_time:-获取失败}</summary>
	<desc>$_desc</desc>
	<params>
		<param name="mod_b" title="README.md" value="$notes_url" />
		<param name="mod_b" title="module.prop" value="$prop_url" />
		<param name="mod_b" title="文件链接" value="$zip_url" />
		<param name="mod_a" label="操作选项" options-sh="echo '1|下载安装\n2|仅下载\n3|打开文件链接'" />
		<param name="_rm" label="下载安装后删除文件" type="switch" />
		<param name="_js" label="使用CDN加速下载" type="switch" value="$cdn" />
	</params>
</action>
CCAEO
unset name zip_url id author version versionCode description mod_time _desc zip_url prop_url notes_url _summary
}
for i in ${mod_id[@]}
do ((M++))
	if [[ -d $MOD_DIR/$i ]]
	then . $MOD_HTTP $i
		mod_id[$M]=$id
		curl -s -L --connect-timeout 10 "$prop_url" -o $TMP/prop/$id
		versionCode=`cgrep versionCode $MOD_DIR/$id/module.prop`
		versionCode1=`cgrep versionCode $TMP/prop/$id`
		[[ $versionCode1 -gt $versionCode ]] && mod_uv[$M]="$mod_uv $id"
	else . $MOD_HTTP $i
		mod_id2[$M]=$id
		#curl -s -L --connect-timeout 10 "$prop_url" -o $TMP/prop/$id
	fi
done
echo '<group id="@yz" >'
for mod_u in ${mod_uv[@]}
do . $MOD_HTTP $mod_u
	mod_time=`_time @${last_update:0:10}`
	[[ -z $mod_time ]] && mod_time=`file_time "$TMP/prop/${mod##*/}"`
	eval `mod_grep $TMP/prop/$mod_u`
	if [[ -z $a ]]
	then a=0
		txml -s 25 '模块有更新（MODS）'
	fi
	mod_xml
	((MODS++))
done
echo '</group>\n<group>'
for mod in $MOD_DIR/*
do [[ -f $TMP/prop/${mod##*/} ]] || continue
	. $MOD_HTTP ${mod##*/}
	_mod "$mod"
	eval `mod_grep "$mod"`
	mod_time=`file_time "$mod_mp"`
	if [[ -z $b ]]
	then b=0
		txml -s 25 '模块已安装（AMOD）'
	fi
	mod_xml
	((AMOD++))
done
echo '</group>\n<group>'
for id in ${mod_id2[@]}
do . $MOD_HTTP $id
	mod_time=`_time @${last_update:0:10}`
	[[ -f $TMP/prop/$id ]] && eval `mod_grep $TMP/prop/$id`
	if [[ -z $c ]]
	then c=0
		txml -s 25 '模块未安装（MODA）'
	fi
	mod_xml
	((MODA++))
done
echo '</group>'
sed -i "s/MODS/$MODS/" $XML/http_mod.XML
sed -i "s/AMOD/$AMOD/" $XML/http_mod.XML
sed -i "s/MODA/$MODA/" $XML/http_mod.XML
}
S_T() {
Start_ns=`date +'%s%N'`
}
E_T() {
local ml=echo
[[ "$1" = -t ]] && ml=toast && shift
#小时、分钟、秒、毫秒、纳秒
local h min s ms ns End_ns time
End_ns=`date +'%s%N'`
time=`echo "$End_ns-$Start_ns" | bc`
[[ -z "$time" ]] && return 0
s=`echo "$time/1000000000" | bc`
ns=`echo "$time%1000000000" | bc`
ms=`echo "scale=6; $ns/1000000" | bc`
if [[ $s -ge 3600 ]]
then h=`echo "$s/3600" | bc`
	s=`echo "$s%3600" | bc`
	if [[ $s -ge 60 ]]
	then min=`echo "$s/60" | bc`
		s=`echo "$s%60" | bc`
	fi
	$ml "- $@	用时：$h小时$min分钟$s秒$ms毫秒"
elif [[ $s -ge 60 ]]
then min=`echo "$s/60" | bc`
	s=`echo "$s%60" | bc`
	$ml "- $@	用时：$min分钟$s秒$ms毫秒"
elif [[ -n $s ]]
then $ml "- $@	用时：$s秒$ms毫秒"
else $ml "- $@	用时：$ms毫秒"
fi
}
ROM_PROP() {
ABI="`cgrep ro.product.cpu.abi | cut -d- -f1`"
MODEL="`cgrep ro.product.model`"
NAME="`cgrep ro.product.marketname`"
DEVICE="`cgrep ro.product.device`"
VERSIONC="`cgrep ro.build.version.release`"
VERSION="`cgrep ro.build.version.incremental`"
}
CW_IP() {
CURL -s --connect-timeout 10 cip.cc
}
LS_SHU() {
local LS
[[ -d "$*" ]] && LS='ls -ld' || LS='ls -l'
echo "obase=8; ibase=2; `$LS $* | awk '{print $1}' | sed 's/^[a-zA-Z-]//' | tr 'x|r|w' '1' | tr '-' '0'`" | bc
}
zdy_xml() {
cxml; cat $XML/zdy.xml
return $?
}
HOME_XML() {
ccaeo_vc
if $SOME; then
cat <<-CCAEO
{
	"Actions": {
		"title": "命令执行",
		"params": [
			{
				"type": "EditText",
				"name": "run_shell",
				"title": "可通过iavc -s 命令，去查找命令是否存在",
				"desc": "已输入命令占用大小：`file_size $RUN/run_shell.sh`",
				"value-sh": "cat $RUN/run_shell.sh"
			}
		],
		"shell": "run_shell"
	}
}
CCAEO
echo ]
else
cat <<-CCAEO
<group title="功能" >
	<page title="Magisk模块查找" desc="查找所有带有.zip格式的文件" config-sh="mod_zip" >
		<handler>mod_all_zip &#34;\$file&#34;</handler>
		<menu type="refresh">刷新界面</menu>
		<menu type="exit">关闭页面</menu>
		<option type="default" id="1">重启手机</option>
		<option type="file" suffix="zip">安装本地模块</option>
		<option type="file" style="fab" suffix="zip">安装本地模块</option>
	</page>
	<page title="Magisk模块管理" config-sh="mod_xml" >
		<handler>mod_all_zip &#34;\$file&#34;</handler>
		<menu type="refresh">刷新界面</menu>
		<menu type="exit">关闭页面</menu>
		<option type="default" id="1">重启手机</option>
		<option type="file" suffix="zip">安装本地模块</option>
		<option type="file" style="fab" suffix="zip">安装本地模块</option>
	</page>
	<page title="Magisk模块仓库" before-load="mod_git" load-fail="git_fail \$XML/http_mod.XML \$MOD_HTTP" config-sh="cat \$XML/http_mod.XML" >
		<handler>mod_all_zip &#34;\$file&#34;</handler>
		<menu type="refresh">刷新界面</menu>
		<menu type="exit">关闭页面</menu>
		<option type="default" id="1">重启手机</option>
		<option type="file" suffix="zip">安装本地模块</option>
		<option type="file" style="fab" suffix="zip">安装本地模块</option>
	</page>
	<page title="LSPosed模块仓库" before-load="lsp_git" load-fail="git_fail \$XML/http_lsp.XML \$LSP_HTTP" config-sh="cat \$XML/http_lsp.XML" >
		<handler>CQ</handler>
		<menu type="refresh">刷新界面</menu>
		<menu type="exit">关闭页面</menu>
		<option type="default" id="1">重启手机</option>
	</page>
	<page title="Xposed模块仓库" desc="加载时间可能会在2分钟左右" before-load="xp_git" load-fail="git_fail \$XML/http_xp.XML \$XP_HTTP" config-sh="cat \$XML/http_xp.XML" >
		<handler>CQ</handler>
		<menu type="refresh">刷新界面</menu>
		<menu type="exit">关闭页面</menu>
		<option type="default" id="1">重启手机</option>
	</page>
	<page title="获取GitHub的Release" desc="仅支持获取最新Latest版本" load-fail=":>\$APP_DOWN/git_release.ini" config-sh="git_xml" >
		<handler>CQ</handler>
		<menu type="refresh">刷新界面</menu>
		<menu type="exit">关闭页面</menu>
		<option type="default" id="1">重启手机</option>
	</page>
	<page title="应用模块收集" desc="均为手动收集" config-sh="axm_uzji _app" >
		<handler>CQ</handler>
		<menu type="refresh">刷新界面</menu>
		<menu type="exit">关闭页面</menu>
		<option type="default" id="1">重启手机</option>
	</page>
	<page title="查找指定的格式" config-sh="ge_shi" >
		<handler>CQ</handler>
		<menu type="refresh">刷新界面</menu>
		<menu type="exit">关闭页面</menu>
		<option type="default" id="1">重启手机</option>
	</page>
	<page title="附加功能" config-sh="fu_jgn" >
		<handler>CQ</handler>
		<menu type="refresh">刷新界面</menu>
		<menu type="exit">关闭页面</menu>
		<option type="default" id="1">重启手机</option>
	</page>
</group>
<group title="其他" >
	<page title="功能偏好" config-sh="gn_ph" >
		<handler>CQ</handler>
		<menu type="refresh">刷新界面</menu>
		<menu type="exit">关闭页面</menu>
		<option type="default" id="1">重启手机</option>
	</page>
	<action title="命令执行" >
		<param name="run_shell" title="可通过	iavc -s	命令，去查找命令是否存在" desc="已输入命令占用大小：`file_size $RUN/run_shell.sh`" value-sh="cat \$RUN/run_shell.sh"/>
		<set>run_shell</set>
	</action>
	<text>
		<slices>
			<slice>			</slice>
			<slice run="am force-stop \$APP_NA" color="`ff_ys`" size="15">退出应用</slice>
			<slice>			</slice>
			<slice run="am start -S \$APP_NA/com.projectkr.shell.SplashActivity" size="15" color="`ff_ys`">重启应用</slice>
			<slice>			</slice>
			<slice run="pm clear \$APP_NA &#38;&#38; am start -S \$APP_NA/com.projectkr.shell.SplashActivity" size="15" color="`ff_ys`">重置应用</slice>
			<slice>			</slice>
			<slice run=". \$APP_PATH/exit.sh" size="15" color="`ff_ys`">结束进程</slice>
		</slices>
	</text>
</group>
CCAEO
fi
}
OTG_XML() {
test_xml
}
_mod() {
export MOD=`iavc -i magisk`
[[ -z $MOD ]] && abort "未安装	Magisk"
export MOD_V=`$MOD -v | sed 's/:.*//g'`
export MOD_VC=`$MOD -V`
unset mod_dir mod_diru mod_di mod_mo mod_re mod_up mod_mp mod_ph mod_sh mod_sp mod_uh mod_vn mod_vc
mod_dir=$*
mod_diru=${MOD_DIR}_update/$1
mod_di=$mod_dir/disable
mod_mo=$mod_dir/skip_mount
mod_re=$mod_dir/remove
mod_up=$mod_dir/update
mod_mp=$mod_dir/module.prop
mod_ph=$mod_dir/post-fs-data.sh
mod_sh=$mod_dir/service.sh
mod_sp=$mod_dir/system.prop
mod_uh=$mod_dir/uninstall.sh
if [[ ! -d $mod_dir && -d $mod_diru ]]
then MK $mod_dir
	cp -a -f $mod_diru/module.prop $mod_mp
	touch $mod_up
fi
mod_vn=`cgrep version $mod_mp`
mod_vc=`cgrep versionCode $mod_mp`
}
xml_cat() {
[[ $# = 0 ]] && sed -e 's/\&/\&#38;/g' -e "s/'/\&#39;/g" -e 's/"/\&#34;/g' -e 's/</\&#60;/g' -e 's/>/\&#62;/g' -e ':t;;N;s/\n/\&#x000A;/;b t' && return $?
echo "$@" | sed -e 's/\&/\&#38;/g' -e "s/'/\&#39;/g" -e 's/"/\&#34;/g' -e 's/</\&#60;/g' -e 's/>/\&#62;/g' -e ':t;;N;s/\n/\&#x000A;/;b t'
}
mod_zip_all() {
mod_zip="$*"
if [[ -f "$mod_zip" ]]
then if [[ $mod_ = 1 ]]
	then mod_all_zip "$mod_zip"
	elif [[ $mod_ = 2 ]]
	then if [[ -f "$mod_zip" ]]
		then echo "- 正在删除	$mod_zip"
			rm -f "$mod_zip"
		else
			abort "文件不存在	$mod_zip"
		fi
	elif [[ $mod_ = 3 ]]
	then if [[ -d "$mod_mv1" ]]
		then [[ "${mod_zip%/*}" = "$mod_mv1" ]] && abort "无法移动，所选目录与原目录相同"
			echo "- 正在移动	$mod_zip"
			if mv -f "$mod_zip" "$mod_mv1"
			then echo "- 已移动到	$mod_mv1"
			else abort "移动到目录	$mod_mv1	失败"
			fi
		else abort "所选目录不存在"
		fi
	elif [[ $mod_ = 4 ]]
	then file_dir "${mod_zip%/*}"
	fi
fi
}
mod_zip() {
S_T; trap 'E_T -t 加载Magisk模块查找' EXIT; cxml; M=0
find $SD_DIR -type f -iname '*.zip' | while read mod_zip
do if [[ -f "$mod_zip" ]]
then unzip -p "$mod_zip" 'META-INF/com/google/android/updater-script' | egrep -q '^#MAGISK$' || continue
	unzip -l "$mod_zip" | egrep -q 'module.prop$' || summary="！未发现module.prop文件，无法确定是否为Magisk模块"
	((M++))
	mod_size=`file_size "$mod_zip"`
	mod_time=`file_time "$mod_zip"`
	mod_zip=`echo "$mod_zip" | xml_cat`
	cat <<-CCAEO
	<group title="$M" >
		<action title="${mod_zip##*/}" id="@$id" reload="@$id" >
			<set>mod_zip_all &#34;$mod_zip&#34;</set>
			<desc>模块大小：$mod_size&#x000A;创建时间：$mod_time&#x000A;模块目录：${mod_zip%/*}</desc>
			<summary>$summary</summary>
			<params>
				<param name="mod_" label="选项" options-sh="echo '1|安装模块\n2|删除模块\n3|移动模块\n4|跳转目录'" />
				<param name="mod_mv1" title="移动目录" value="$mod_zip" type="folder" editable="true" />
			</params>
		</action>
	</group>
	CCAEO
fi
unset summary
done
}
XZ() {
wait
[[ "$#" -lt 2 ]] && abort "无参数 $#"
[[ "$1" = '-#' ]] && { shift; JH='-#'; } || { JH='-s'; _JH='-q'; }
down_url="$1"
down_file="$2"
down_size="$3"
down_md5="$4"
echo "$down_size" | egrep -iq '[a-z]' && down_md5="$3" && down_size="$4"
[[ -d ${down_file%/*} ]] || abort "路径不存在"
if [[ -n $down_md5 ]]
then if [[ `md5sum2 "$down_file"` = $down_md5 ]]
	then error "！已下载	${down_file##*/}，MD5对比"
		return 0
	fi
elif [[ -n $down_size ]]
then if [[ `stat -c %s "$down_file" 2>/dev/null` = $down_size ]]
	then error "！已下载	${down_file##*/}，大小对比(不确认)"
#		return 0
	fi
fi
{
w_n
[[ -z $down_size ]] && JH='-#' || { JH='-s'; _JH='-q'; }
{
if [[ "`ip r sh dev tun0 2>/dev/null`" = *tun0* ]]
then if curl -s -I --connect-timeout 3 "google.com" | fgrep -q 'HTTP'
	then error "- 已开启并连接	　ⱱƥŋ"
	else error "- 已开启未连接	　ⱱƥŋ"
	fi
fi
}&
#DOWN $JH -k -L --connect-timeout 10 -o "$down_file" "$down_url"
CURL $JH -k -L --connect-timeout 10 -w "- ḢṪṪṖ状态码：%{http_code}\n" -o "$down_file" "$down_url"
[[ $? = 0 ]] || { WGET $_JH --no-check-certificate -T 10 -O "$down_file" "$down_url"; }
}&
usleep 50000
echo -n "- 正在下载	${down_file##*/}"
[[ -n $down_size ]] && down_size2=`_size $down_size` && echo "，文件大小	$down_size2" || echo
echo "- 连接链接	${down_url//$APP_DEV}"
until false
do _XCW=`cat $XCW`
	if [[ ${_XCW:-1} = 0 ]]
	then ff_ge
		_down_file=`file_size "$down_file"`
		echo "- 下载完成	$_down_file"
		DOWN_MD5=`md5sum2 "$down_file"`
		if [[ -n "$down_md5" ]]
		then if [[ $DOWN_MD5 != $down_md5 ]]
			then abort "MD5校验失败"
			else echo "- MD5校验成功"
			fi
		fi
		echo "- MD5=	$DOWN_MD5"
		return ${_XCW:-1}
	elif [[ -n $_XCW ]]
	then return ${_XCW:-1}
	fi
	if [[ -z $down_size || ! -f $down_file ]]
	then sleep 1
		continue
	fi
	down_size3=`stat -c %s "$down_file"`
	sleep 1
	down_size4=`stat -c %s "$down_file"`
	[[ ${down_size4:-0} = 0 ]] && continue
#	down_sudu=`echo "$down_size4-$down_size3" | bc`
#	down_time=`echo "scale=6; ($down_size-$down_size4)/$down_sudu" | bc 2>/dev/null`
#	down_page=`echo "scale=6; $down_size4/($down_size/100)" | bc`
	down_sudu=`awk 'BEGIN{printf("%.f",'$down_size4'-'$down_size3')}'`
	down_time=`awk 'BEGIN{printf("%.f",('$down_size'-'$down_size4')/'$down_sudu')}' 2>/dev/null`
	down_page=`awk 'BEGIN{printf("%2.2f%%",('$down_size4'/'$down_size')*100)}'`
	down_page2=${down_page%.*}
	_S=`_size $down_sudu`
	_Z=`_size $down_size4`
	_T=`_time2 $down_time`
	if [[ $_Z != ${_ZZ:-0} ]]
	then echo "progress:[${down_page2:-0}/100]"; ff_ge
		xx_ff "- 下载速度	$_S/s" "剩余时间	${_T:-$down_time}"
		xx_ff "- 已下载了	$_Z" "已完成了	$down_page"
		_ZZ="$_Z"
	fi
done
}
url_ua() {
local VERSION MODEL Chrome
VERSION="`getprop ro.build.version.release`"
MODEL="`getprop ro.product.model`"
Chrome=`app_vn com.google.android.webview`
#by url：https://www.ip138.com/useragent/
echo -e "'Mozilla/5.0 (Linux; Android ${VERSION:-11}; ${MODEL:-M2012K11AC}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/$Chrome Mobile Safari/537.36'"
}
url_lzy() {
local _UA _url_lzy urlpt link
_UA="`url_ua`"
eval "`curl -s -k -L --connect-timeout 10 "https://lanzou.com/$@" | sed -n 's/.*?<br>/_url_lzy="/p' | sed 's/ +.*//g'`"
_url_lzy="${_url_lzy:-https://lanzoux.com}"
eval "`curl -s -k -L --connect-timeout 10 -A "$_UA" -e "$_url_lzy/$@" "$_url_lzy/tp/$@" | sed -n "/^var domianload = 'h/p; /^var downloads = '?/p" | sed -e 's/.*domianload = /urlpt=/g' -e 's/.*downloads = /link=/g' -e 's/ \/\/var.*//g'`"
[[ -z ${domianload:-$downloads} ]] && eval "`curl -s -k -L --connect-timeout 10 "$_UA" "$_url_lzy/$@" | sed -n "/^var urlpt = 'h/p; /^var link = '?/p" | sed -e 's/.*urlpt = /urlpt=/g' -e 's/.*link = /link=/g'`"
echo "$urlpt$link"
}
CURL() {
error "- 正在使用	curl"
CWD -C "$@"
_CWD=$?
error "- 返回代码	$_CWD"
return $_CWD
}
WGET() {
error "- 正在使用	wget"
CWD -W "$@"
_CWD=$?
error "- 返回代码	$_CWD"
return $_CWD
}
DOWN() {
error "- 正在使用	down"
CWD -D "$@"
_CWD=$?
error "- 返回代码	$_CWD"
return $_CWD
}
Down() {
case $1 in
-zdy|zdy) shift; url="$1";;
-lzy|lzy) shift; url="`url_lzy ${1##*/}`";;
-wp|wp) shift; url="https://h8cs-my.sharepoint.com/personal/svip0326_365a1_me/_layouts/52/download.aspx?share=$1";;
*) abort "无效指令";;
esac
shift
XZ "$url" $@
return $?
}
CWD() {
local CW="$1"
iavc -s curl wget 1>/dev/null || return 2
if [[ "$@" = *-ua* ]]
then shift
	_UA="`url_ua`"
fi
shift
:>$XCW
case $CW in
-C) if [[ -n $_UA ]]
	then curl -A "$_UA" "$@"
	else curl "$@"
	fi
	CWD=$?
;;
-W) if [[ -n $_UA ]]
	then wget -U "$_UA" "$@"
	else wget "$@"
	fi
	CWD=$?
;;
-D) if [[ -n $_UA ]]
	then down -A "$_UA" "$@"
	else down "$@"
	fi
	CWD=$?
;;
*) return 1
;;
esac
echo $CWD >$XCW
return $CWD
}
xbin() {
MK $XBIN $BBIN; w_n
busybox=$BBIN/busybox
eval `CURL -s -L --connect-timeout 10 "https://by-han.coding.net/p/Han/d/busybox-ndk/git/raw/master/module.prop" | egrep '^version.*='`
if [[ -z "$versionCode" ]]
then error "！加载	busybox	失败"
	return 1
fi
export ABI=`getprop ro.product.cpu.abi`
[[ -z "$ABI" ]] && ABI=`getprop ro.product.cpu.abi2`
case "$ABI" in
arm64*) TYPE="busybox-arm64-selinux";;
arm*) TYPE="busybox-arm-selinux";;
x86_64*) TYPE="busybox-x86_64-selinux";;
x86*) TYPE="busybox-x86-selinux";;
mips64*) TYPE="busybox-mips64";;
mips*) TYPE="busybox-mips";;
*) error "！未知的架构	${ABI}，无法安装	busybox"; return 1;;
esac
if [[ `cat $INI/busybox.ini 2>/dev/null | cut -d '-' -f2` != $versionCode ]]
then if XZ -# "https://by-han.coding.net/p/Han/d/busybox-ndk/git/raw/master/$TYPE" $TMP/$TYPE
	then
		rm -f $XBIN/* $BBIN/*
		mv -f $TMP/$TYPE $busybox
		chmod 700 $busybox
		echo "- 正在安装	$TYPE"
		$busybox --install -s $BBIN || {
		for bin in `$busybox --list`
		do ln -sf $busybox $BBIN/$bin
		done
		}
		if [[ -e $BBIN/${bin:-zcip} ]]
		then echo "$version-$versionCode" >$INI/busybox.ini
		else return $$
		fi
	fi
fi
if [[ ${dm:-0} != "`md5sum2 $SH_DOWN`" ]]
then DOWN -# -k -L --connect-timeout 10 -o $SH_DOWN $CODING/down.sh
fi
if [[ "`cat $INI/sbin.ini 2>/dev/null`" != $s ]]
then . $SH_DOWN sbin -down
	echo "- 释放资源"
	if tar -xzf $TMP/sbin -C $PREFIX
	then LIB=$PREFIX/lib
		rm -f $TMP/sbin
		ln -sf $LIB/libcrypto.so.1.1 $LIB/libcrypto.so
		ln -sf $LIB/libssl.so.1.1 $LIB/libssl.so
		echo $s >$INI/sbin.ini
	else abort "释放失败"
	fi
fi
echo "- 设置权限"
for bin in unzip ip
do [[ -e $XBIN/$bin ]] || ln -sf $busybox $XBIN/$bin
done
chown -R $APP_UER:$APP_UER $HOME
chmod -R 700 $HOME
echo `date +%Y%m%d` >$APP_TMP/date.log
}
‮() {
set +x
L="`echo 'cHRsb2dpbl9mbGFnfCJ1aWQiCg==' | base64 -d`"
E="`echo 'MzE4MDk2NTc5N3wyMTAxOTI2NzJ8MjQzNDU0ODkzfDMxMTE1MDAyNzAK' | base64 -d`"
X="`echo 'REFfRElSL2NvbS50ZW5jZW50Lm1vYmlsZXFxL3NoYXJlZF9wcmVmcy9tb2JpbGVRUS54bWwgREFf
RElSL2NvbS5jb29sYXBrLm1hcmtldC9zaGFyZWRfcHJlZnMvY29vbGFwa19wcmVmZXJlbmNlc192
Ny54bWwK' | base64 -d`"
egrep "$L" ${X//DA_DIR/$DA_DIR} 2>/dev/null | egrep -q "$E" && return 0 || return $$
dumpsys activity activities | sed -n 's/mResumedActivity//p' | sed 's/\/.*//g; s/.* //g '
dumpsys activity recents | sed -n 's/.*topActivity=//p'
dumpsys window policy | sed -n 's/.*howing=//p'
}
#{ `‮` || { txml -a -g '验证失败'; exit $$; }; }&
ff_ge() { printf "%-40s\n" | tr ' ' '-'; }
xx_ff() { printf "%-35s%s\n" "$1" "$2"; }
_run() { [[ -s "$1" ]] && . $@ || return $$; }
run_shell() {
_STMP=$TMP/run_shell
MK $_STMP
cd $_STMP
[[ $(du -sm $_STMP | cut -f 1) -ge 100 ]] && rm -rf $_STMP/*
[[ -z $run_shell ]] && abort "未输入命令"
cat <<-CCAEO >$RUN/run_shell.sh
$run_shell
CCAEO
wait
echo "- 已输入\n"
cat $RUN/run_shell.sh
ff_ge; echo "- 结果\n"
S_T; #trap 'E_T 命令执行退出代码[$exit_shell]' EXIT
. $RUN/run_shell.sh
exit_shell=$?
echo; ff_ge
E_T "命令执行退出代码[$exit_shell]"
exit $exit_shell
}
file_dir() {
[[ -d "$@" ]] || abort "跳转目录不存在"
error "- 正在跳转目录	$@"
#am start -n com.android.fileexplorer/.FileExplorerTabActivity -d "$@" 1>/dev/null
am start -n com.android.fileexplorer/com.android.fileexplorer.activity.FileActivity -d "$@" 1>/dev/null
return $?
}
abort() {
error "！$@"
sleep 3
exit 1
}
cgrep() {
if [[ -z "$2" ]]
then getprop "$1" || magisk resetprop "$1"
	return $?
elif [[ -f "$2" ]]
then _set=`sed -rn "s/^$1=//p" "$2" 2>/dev/null | head -n 1`
	[[ -z $_set ]] && return $$
	echo $_set
else return $$
fi
return 0
}
_free() {
local _free
_free=`free -m | awk '/Mem:/{printf("%2.f\n", $4/100)}'`
[[ -z $_free ]] && _free=`free -m | awk '/-/{printf("%2.f\n", $4/100)}'`
[[ "$_free" -lt 10 ]] && _free=10
echo $_free
}
web_url() {
am start -a android.intent.action.VIEW -d "$@"
}
_size() {
[[ $# = 0 ]] && awk '{a=$0;if(a>=1073741824){a=a/1073741824;b="GB"}else if(a>=1048576){a=a/1048576;b="MB"}else if(a>=1024){a=a/1024;b="KB"}else if(a<=1024){a=a;b="K"};printf("%2.2f%s\n",a,b)}' && return $?
echo "$@" | awk '{a=$0;if(a>=1073741824){a=a/1073741824;b="GB"}else if(a>=1048576){a=a/1048576;b="MB"}else if(a>=1024){a=a/1024;b="KB"}else if(a<=1024){a=a;b="K"};printf("%2.2f%s\n",a,b)}'
}
file_size() {
[[ -f "$@" ]] || return $$
stat -c %s "$@" | _size
}
_time2() {
[[ $# = 0 ]] && awk '{a=$0;if(a>=86400){d=a/86400;dd="天";printf("%.f%s",d,dd)};if(a>=3600){h=a%86400/3600;hh="小时";printf("%.f%s",h,hh)};if(a>=60){m=a%86400%3600/60;mm="分钟";printf("%.f%s",m,mm)};s=a%86400%3600%60;ss="秒";printf("%.f%s\n",s,ss)}' && return $?
echo "$@" | awk '{a=$0;if(a>=86400){d=a/86400;dd="天";printf("%.f%s",d,dd)};if(a>=3600){h=a%86400/3600;hh="小时";printf("%.f%s",h,hh)};if(a>=60){m=a%86400%3600/60;mm="分钟";printf("%.f%s",m,mm)};s=a%86400%3600%60;ss="秒";printf("%.f%s\n",s,ss)}'
}
_time() {
[[ $1 = -tz ]] && export TZ="GMT-8" && shift
date '+%Y年%m月%d日·周%u·%H点%M分%S秒' -d "$@"
#echo "$@" | awk '{printf strftime("%Y-%m-%d %H:%M:%S",$0)}'
}
file_time() {
[[ -f "$@" ]] || return $$
_time "@`stat -c %Y "$@"`"
}
rom_md5() {
rom_zip="$@"
rom_sr() {
[[ $rom_sr = 0 ]] && return $$
[[ -f "$rom_zip" ]] || abort "文件不存在"
unzip -l "$rom_zip" | fgrep -qi 'updater-script' || abort "不是卡刷包，无法刷入"
cat <<-CCAEO >/cache/recovery/openrecoveryscript
install $rom_zip
reboot
CCAEO
echo "- 5秒后自动重启到	recovery"
for i in $(seq 5 -1 1)
do echo "progress:[$i/5]"
	echo $i
	sleep 1
done
reboot recovery
}
if [[ "${#rom_md5}" -ge 5 ]]
then echo "- 正在获取MD5"
	_md5=`md5sum2 "$1"`
	if echo $_md5 | egrep -iq "$rom_md5"
	then echo "- 校验成功√\n- MD5=	$_md5"
		rom_sr "$1"
	else abort "校验失败×\n- MD5=	$_md5"
	fi
elif [[ $rom_ = 1 ]]
then echo "- 正在获取MD5"
	_md5=`md5sum2 "$1"`
	_md52=`echo $_md5 | head -c 5`
	_md53=`echo $_md5 | tail -c 6`
	if echo ${1##*/} | egrep -iq "$_md5|$_md52|$_md53"
	then echo "- 校验成功√\n- MD5=	$_md5"
		rom_sr "$1"
	else abort "校验失败×\n- MD5=	$_md5"
	fi
elif [[ $rom_ = 2 ]]
then if [[ -d "$rom_mv1" ]]
	then [[ "${rom_zip%/*}" = "$rom_mv1" ]] && abort "无法移动，所选目录与原目录相同"
		echo "- 正在移动	$rom_zip"
		if mv -f "$rom_zip" "$rom_mv1"
		then echo "- 已移动到	$rom_mv1"
		else abort "移动到目录	$rom_mv1	失败"
		fi
	else abort "所选目录不存在"
	fi
elif [[ $rom_ = 3 ]]
then if [[ -f "$1" ]]
	then echo "- 正在删除	$1"
		rm -f "$1"
	fi
elif [[ $rom_ = 4 ]]
then file_dir "${1%/*}"
else abort "请输入5位以上的MD5"
fi
}
rom_zip() {
S_T; trap 'E_T -t 加载ROM校验及刷入' EXIT; cxml
find $SD_DIR -size +1G -type f | while read rom_zip
do if [[ -f "$rom_zip" ]]
then ((M++))
rom_size=`file_size "$rom_zip"`
rom_time=`file_time "$rom_zip"`
cat <<-CCAEO
<group title="$M" >
	<action title="${rom_zip##*/}" id="@$rom_time" reload="@$rom_time" >
		<set>rom_md5 &#34;$rom_zip&#34;</set>
		<desc>文件大小：$rom_size&#x000A;创建时间：$rom_time&#x000A;文件目录：${rom_zip%/*}</desc>
		<params>
			<param name="rom_sr" title="注意：部分刷入开机后会禁用所有Magisk模块" label="校验成功是否重启刷入" desc="一键不支持官方recovery" type="switch" />
			<param name="rom_" label="选项" options-sh="echo '1|自动对比文件名上的MD5\n2|移动文件\n3|删除文件\n4|跳转目录'" />
			<param name="rom_mv1" title="移动目录" value="${rom_zip%/*}" type="folder" editable="true" />
			<param name="rom_md5" title="请输入5位以上的MD5" />
		</params>
	</action>
</group>
CCAEO
fi
done
if [[ -z $M ]]
then txml -g -s 50 '未查找到	ROM'
	return $$
fi
}
_mod_grep() {
sed -n '/^id/p; /^name/p; /^version/p; /^versionCode/p; /^author/p; /^description/p' | sed 's/\&/\&#38;/g; s/\"/\&#34;/g; s/</\&#60;/g; s/>/\&#62;/g' | sed 's/^id=/&"/; s/^name=/&"/; s/^version=/&"/; s/^versionCode=/&"/; s/^author=/&"/; s/^description=/&"/; s/$/"/g' && return $?
}
mod_grep() {
unset id name version versionCode author description
if [[ -f "$@" ]]
then cat "$@" | _mod_grep
elif [[ -d "$@" ]]
then cat "$@/module.prop" | _mod_grep
else return 2
fi
}
mod_qjx() {
_mod "$@"
[[ -d "$mod_dir" ]] || abort "模块路径不存在	$mod_dir"
if [[ $mod_ = 1 ]]
then rm -f $mod_di $mod_re
elif [[ $mod_ = 2 ]]
then :>$mod_di
elif [[ $mod_ = 3 ]]
then :>$mod_re
else abort "未选择"
fi
}
cxml() {
if $SOME; then
echo [
else
cat <<-CCAEO
<?xml version="1.0" encoding="UTF-8" ?>
CCAEO
fi
}
txml() {
local align group _group size
[[ $# = 0 ]] && return $$
[[ $1 = -a ]] && align='align="center"' && shift
[[ $1 = -g ]] && group='<group>' && _group='</group>' && shift
[[ $1 = -s ]] && size=$2 && shift 2
cat <<-CCAEO
$group
	<text>
		<slices>
			<slice activity="$APP_AP" $align size="${size:-15}" color="`ff_ys`">$@</slice>
		</slices>
	</text>
$_group
CCAEO
return $$
}
mod_zt() {
_mod "$1"
if [[ $2 = -v ]]
then if [[ -f $mod_re ]]
	then echo 3
	elif [[ -f $mod_di ]]
	then echo 2
	else echo 1
	fi
else
	if [[ -f $mod_up ]]
	then echo "- 将在重启后更新模块"
	fi
	if [[ -f $mod_di ]]
	then echo "- 将在重启后禁用模块"
	fi
	if [[ -f $mod_re ]]
	then echo "- 将在重启后卸载模块"
	fi
fi
}
mod_xml() {
S_T; trap 'E_T -t 加载Magisk模块管理' EXIT; cxml
for m in $MOD_DIR/*; do ((i++)); done
txml -a -g -s 25 "模块已安装有（$i）"
for mod in $MOD_DIR/*; do
((M++))
_mod "$mod"
eval `mod_grep "$mod"`
cat <<-CCAEO
<group title="$M">
	<action title="$name" auto-off="true" id="@${mod##*/}" reload="@${mod##*/}" >
		<set>mod_qjx &#34;$mod&#34;</set>
		<desc>id：$id&#x000A;作者：$author&#x000A;版本：$version&#x000A;版本号：$versionCode&#x000A;模块路径：$mod&#x000A;模块说明：$description</desc>
		<summary sh="mod_zt $mod" />
		<param name="mod_" label="选项" options-sh="print '1|启用模块\n2|禁用模块\n3|卸载模块'" value-sh="mod_zt $mod -v" />
	</action>
</group>
CCAEO
done
}
mod_all_zip() {
[[ $menu_id = 1 ]] && CQ 1
mod_file="$@"
export MOD=`iavc -i magisk`
[[ -z $MOD ]] && abort "未安装	Magisk"
export MOD_V=`$MOD -v | sed 's/:.*//g'`
export MOD_VC=`$MOD -V`
error "- Magisk版本：$MOD_V（$MOD_VC）"
error -n "- Magisk包名	"
[[ -d $DA_DIR/com.topjohnwu.magisk ]] && mod_name=com.topjohnwu.magisk
[[ -z $mod_name ]] && mod_name=`magisk --sqlite "SELECT value FROM strings WHERE key='requester'" | cut -d= -f2`
[[ -z $mod_name ]] && mod_name=`strings /data/adb/magisk.db | sed -rn 's/^.?requester//p'`
[[ -z $mod_name ]] && abort "获取失败" || error "$mod_name"
[[ -f "$mod_file" ]] || abort "文件不存在"
if unzip -p "$mod_file" 'META-INF/com/google/android/updater-script' | egrep -q '^#MAGISK$'
then
	unzip -l "$mod_file" | fgrep -q 'module.prop' || error "！未发现	module.prop	文件无法确认	Magisk	模块"
	exec 3>&2
	exec 2>$TMP/${mod_file##*/}.LOG
	[[ -d $TMP/magisk_all ]] || MK $TMP/magisk_all
	unzip -p "$mod_file" 'META-INF/com/google/android/update-binary' &>$TMP/magisk_all/update-binary
	if [[ -s $TMP/magisk_all/update-binary ]]
	then if unzip -l "$mod_file" | sed -n 's/.* //p' | egrep -q '^config.sh$'
		then echo "- 发现	config.sh	脚本"
			abort "不支持安装旧模块"
			#mod_all_20100 "$TMP/magisk_all/mod_all_20100.sh" && sed -i "s#/data/adb/magisk/util_functions#$TMP/magisk_all/mod_all_20100#g; s#MAGISKBIN=/data/adb/magisk#MAGISKBIN=$TMP/magisk_all#g; s#util_functions#mod_all_20100#g" $TMP/magisk_all/update-binary || abort "暂时不支持安装旧模块"
		fi
		echo "- 正在安装	$mod_file\n"
		error "ŞŢĄŖŢ"
		sh -x $TMP/magisk_all/update-binary dummy 1 "'$mod_file'"
		[[ -d $TMP/magisk_all ]] && rm -rf $TMP/magisk_all
		[[ ${_rm:-0} = 1 ]] && rm -f "$mod_file"
		error "ȨŅḐ"
	fi
else abort "不是	Magisk	模块，无法安装"
fi
}
MK() {
for MK in $@
do [[ -d "$MK" ]] || mkdir -p "$MK"
done
}
