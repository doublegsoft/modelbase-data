<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4c.ftl" as modelbase4c>
<#if license??>
${c.license(license)}
</#if>
#ifndef __${app.name?upper_case}_ERROR_H__
#define __${app.name?upper_case}_ERROR_H__

#ifdef __cplusplus
extern "C"
{
#endif

/*!
** 【Together 统一错误码解码宏】
** 提取正整数错误码中的模块 (xx)、子对象 (yy) 以及具体错误序号 (zz)。
*/
#define ${namespace?upper_case}_ERR_MODULE(err)   ((err) / 10000)
#define ${namespace?upper_case}_ERR_SUBOBJ(err)   (((err) % 10000) / 100)
#define ${namespace?upper_case}_ERR_CODE(err)     ((err) % 100)

/*!
** 【Together 统一错误码枚举定义】
** 编码规则: XXYYZZ (正整数)
**   0  : 成功 (OK)
**   XX : 模块划分 (10 ~ 99)
**   YY : 子对象划分 (00 ~ 99)
**   ZZ : 具体错误 (01 ~ 99)
*/
typedef enum ${namespace?upper_case}_error_e
{
  ${namespace?upper_case}_OK                                = 0,

  /* ======================================================================= */
  /* [10] 基础与系统模块 (Base / System)                                     */
  /* ======================================================================= */
  /* [1000] 系统通用 */
  ${namespace?upper_case}_ERR_SYS_GENERIC                   = 100001, /*!< 系统通用/未知错误        */
  ${namespace?upper_case}_ERR_SYS_NOT_INITIALIZED           = 100002, /*!< 基础运行环境未初始化      */

  /* [1001] 内存对象 */
  ${namespace?upper_case}_ERR_MEM_ALLOC_FAILED              = 100101, /*!< 动态内存申请(malloc)失败  */
  ${namespace?upper_case}_ERR_MEM_NULL_POINTER              = 100102, /*!< 遭遇非法空指针引用        */

  /* [1002] 参数与缓冲区 */
  ${namespace?upper_case}_ERR_PARAM_INVALID                 = 100201, /*!< 入参不合法或超出界限      */
  ${namespace?upper_case}_ERR_PARAM_BUFFER_OVERFLOW         = 100202, /*!< 缓冲区长度不足/溢出      */

  /* [1003] 时钟与任务 */
  ${namespace?upper_case}_ERR_TIME_TIMEOUT                  = 100301, /*!< 操作执行超时              */

  /* ======================================================================= */
  /* [20] 协议与数据帧模块 (Protocol / Frame)                                 */
  /* ======================================================================= */
  /* [2000] 协议解析引擎 */
  ${namespace?upper_case}_ERR_PROTO_FRAME_INCOMPLETE        = 200001, /*!< 接收数据不全(触发半包)    */
  ${namespace?upper_case}_ERR_PROTO_FRAME_CORRUPTED         = 200002, /*!< 协议帧损坏/校验不通过    */

  /* [2001] 帧头 (Header) */
  ${namespace?upper_case}_ERR_PROTO_HDR_MAGIC               = 200101, /*!< 魔数错误 (不是 0x5447)    */
  ${namespace?upper_case}_ERR_PROTO_HDR_VERSION             = 200102, /*!< 不支持的协议版本号        */
  ${namespace?upper_case}_ERR_PROTO_HDR_MSG_TYPE            = 200103, /*!< 未知或非法的消息类型      */
  ${namespace?upper_case}_ERR_PROTO_HDR_CMD_ID              = 200104, /*!< 无法识别的指令码          */

  /* [2002] 载荷 (Payload) */
  ${namespace?upper_case}_ERR_PROTO_PAYLOAD_TOO_LARGE       = 200201, /*!< 载荷长度超过最大限制      */
  ${namespace?upper_case}_ERR_PROTO_PAYLOAD_LEN_MISMATCH    = 200202, /*!< 声明长度与实际载荷不符    */

  /* ======================================================================= */
  /* [30] 存储与文件模块 (Storage / File)                                    */
  /* ======================================================================= */
  /* [3001] 二进制帧文件 */
  ${namespace?upper_case}_ERR_FILE_OPEN_FAILED              = 300101, /*!< 文件打开失败              */
  ${namespace?upper_case}_ERR_FILE_READ_FAILED              = 300102, /*!< 从文件读取数据失败        */
  ${namespace?upper_case}_ERR_FILE_WRITE_FAILED             = 300103, /*!< 向文件写入数据失败        */
  ${namespace?upper_case}_ERR_FILE_UNEXPECTED_EOF           = 300104, /*!< 文件提前遭遇意外结束 EOF  */

  /* ======================================================================= */
  /* [40] 网络通信模块 (Network / Socket)                                    */
  /* ======================================================================= */
  /* [4000] 网络环境与寻址 */
  ${namespace?upper_case}_ERR_NET_ENV_INIT_FAILED           = 400001, /*!< 网络栈(WSA)启动失败       */
  ${namespace?upper_case}_ERR_NET_RESOLVE_LOCAL_IP          = 400002, /*!< 本机活动出口 IP 获取失败  */

  /* [4001] 服务端监听套接字 */
  ${namespace?upper_case}_ERR_NET_SERVER_CREATE             = 400101, /*!< 服务端 Socket 创建失败    */
  ${namespace?upper_case}_ERR_NET_SERVER_BIND               = 400102, /*!< 服务端地址/端口绑定失败   */
  ${namespace?upper_case}_ERR_NET_SERVER_LISTEN             = 400103, /*!< 服务端启动监听失败        */
  ${namespace?upper_case}_ERR_NET_SERVER_ACCEPT             = 400104, /*!< 接入客户端连接失败        */
  ${namespace?upper_case}_ERR_NET_SERVER_CONN_LIMIT         = 400105, /*!< 服务端连接池已满          */

  /* [4002] 客户端连接套接字 */
  ${namespace?upper_case}_ERR_NET_CLIENT_CONNECT            = 400201, /*!< 连接目标服务器失败        */

  /* [4003] 数据收发流 */
  ${namespace?upper_case}_ERR_NET_STREAM_SEND               = 400301, /*!< Socket 发送数据失败       */
  ${namespace?upper_case}_ERR_NET_STREAM_RECV               = 400302, /*!< Socket 接收数据失败       */
  ${namespace?upper_case}_ERR_NET_STREAM_PEER_CLOSED        = 400303, /*!< 连接已被对端关闭          */

  /* [5000] 操作系统通用预留 */
  ${namespace?upper_case}_ERR_OS_GENERIC                    = 500001, /*!< 操作系统未知/通用错误     */

  /* [5001] 进程管理 (Process) */
  ${namespace?upper_case}_ERR_OS_PROC_START_FAILED          = 500101, /*!< 进程启动失败 (包含 fork / popen / exec) */
  ${namespace?upper_case}_ERR_OS_PROC_WAIT_FAILED           = 500102, /*!< 进程等待/回收失败 (waitpid / pclose)   */
  ${namespace?upper_case}_ERR_OS_PROC_ABNORMAL_EXIT         = 500103, /*!< 进程异常退出 (非零状态码/被信号杀死)    */
  ${namespace?upper_case}_ERR_OS_PROC_NOT_FOUND             = 500104, /*!< 目标进程不存在 (PID 无效)               */

  /* [5002] 线程与工作队列 (Thread & Worker Queue) */
  ${namespace?upper_case}_ERR_OS_THREAD_CREATE_FAILED       = 500201, /*!< 线程创建失败 (pthread_create)           */
  ${namespace?upper_case}_ERR_OS_THREAD_JOIN_FAILED         = 500202, /*!< 线程同步/等待结束失败 (pthread_join)    */
  ${namespace?upper_case}_ERR_OS_QUEUE_REJECTED             = 500203, /*!< 任务投递失败 (工作队列已满或已停止)    */

  /* [5003] 同步与锁机制 (Lock & Sync) */
  ${namespace?upper_case}_ERR_OS_LOCK_FAILED                = 500301, /*!< 互斥锁/全局文件锁操作失败 (获取或释放) */
  ${namespace?upper_case}_ERR_OS_COND_FAILED                = 500302, /*!< 条件变量同步失败 (等待或通知异常)       */

  /* [5004] 进程间通信 (IPC) */
  ${namespace?upper_case}_ERR_OS_PIPE_FAILED                = 500401, /*!< 管道通信失败 (创建失败/破裂 EPIPE)     */
  ${namespace?upper_case}_ERR_OS_IPC_FAILED                 = 500402, /*!< 共享内存/信号量等底层 IPC 错误         */

  /* [5005] 系统资源限制 (Resource Limits) */
  ${namespace?upper_case}_ERR_OS_RESOURCE_LIMIT             = 500501, /*!< 系统资源耗尽 (FD描述符/句柄/进程配额)  */
  ${namespace?upper_case}_ERR_OS_SIGNAL_FAILED              = 500502  /*!< 系统信号注册或处理失败                 */
} ${namespace?lower_case}_error_t;

/*!
** 【获取错误码描述文本】
** 
** 将 Together 正整数错误码转化为可读的说明字符串。
**
** @param err 错误码
** @return 指向静态只读错误字符串的指针
*/
static inline const char*
${namespace?lower_case}_error_str(int err)
{
  switch (err) {
    case ${namespace?upper_case}_OK:                             return "Success (OK)";

    /* 10 系统通用 */
    case ${namespace?upper_case}_ERR_SYS_GENERIC:                return "[100001] System generic error";
    case ${namespace?upper_case}_ERR_SYS_NOT_INITIALIZED:        return "[100002] Runtime environment not initialized";
    case ${namespace?upper_case}_ERR_MEM_ALLOC_FAILED:           return "[100101] Memory allocation failed";
    case ${namespace?upper_case}_ERR_MEM_NULL_POINTER:           return "[100102] Null pointer dereference detected";
    case ${namespace?upper_case}_ERR_PARAM_INVALID:              return "[100201] Invalid argument supplied";
    case ${namespace?upper_case}_ERR_PARAM_BUFFER_OVERFLOW:      return "[100202] Buffer capacity overflow";
    case ${namespace?upper_case}_ERR_TIME_TIMEOUT:               return "[100301] Operation timed out";

    /* 20 协议编解码 */
    case ${namespace?upper_case}_ERR_PROTO_FRAME_INCOMPLETE:     return "[200001] Incomplete frame segment received";
    case ${namespace?upper_case}_ERR_PROTO_FRAME_CORRUPTED:      return "[200002] Protocol frame is corrupted";
    case ${namespace?upper_case}_ERR_PROTO_HDR_MAGIC:            return "[200101] Invalid protocol magic (expected 0x5447)";
    case ${namespace?upper_case}_ERR_PROTO_HDR_VERSION:          return "[200102] Unsupported protocol version";
    case ${namespace?upper_case}_ERR_PROTO_HDR_MSG_TYPE:         return "[200103] Unknown message type";
    case ${namespace?upper_case}_ERR_PROTO_HDR_CMD_ID:           return "[200104] Unknown command ID";
    case ${namespace?upper_case}_ERR_PROTO_PAYLOAD_TOO_LARGE:    return "[200201] Payload size exceeds system maximum limit";
    case ${namespace?upper_case}_ERR_PROTO_PAYLOAD_LEN_MISMATCH: return "[200202] Actual payload length mismatches header declaration";

    /* 30 存储文件 */
    case ${namespace?upper_case}_ERR_FILE_OPEN_FAILED:           return "[300101] Failed to open binary file";
    case ${namespace?upper_case}_ERR_FILE_READ_FAILED:           return "[300102] Failed to read from file";
    case ${namespace?upper_case}_ERR_FILE_WRITE_FAILED:          return "[300103] Failed to write to file";
    case ${namespace?upper_case}_ERR_FILE_UNEXPECTED_EOF:        return "[300104] Unexpected EOF while reading file";

    /* 40 网络通信 */
    case ${namespace?upper_case}_ERR_NET_ENV_INIT_FAILED:        return "[400001] Socket environment initialization failed";
    case ${namespace?upper_case}_ERR_NET_RESOLVE_LOCAL_IP:       return "[400002] Failed to resolve active local IP";
    case ${namespace?upper_case}_ERR_NET_SERVER_CREATE:          return "[400101] Failed to create server socket";
    case ${namespace?upper_case}_ERR_NET_SERVER_BIND:            return "[400102] Failed to bind server socket to port";
    case ${namespace?upper_case}_ERR_NET_SERVER_LISTEN:          return "[400103] Failed to listen on server socket";
    case ${namespace?upper_case}_ERR_NET_SERVER_ACCEPT:          return "[400104] Failed to accept client connection";
    case ${namespace?upper_case}_ERR_NET_SERVER_CONN_LIMIT:      return "[400105] Server active client pool is full";
    case ${namespace?upper_case}_ERR_NET_CLIENT_CONNECT:         return "[400201] Failed to connect to server";
    case ${namespace?upper_case}_ERR_NET_STREAM_SEND:            return "[400301] Failed to send stream data";
    case ${namespace?upper_case}_ERR_NET_STREAM_RECV:            return "[400302] Failed to receive stream data";
    case ${namespace?upper_case}_ERR_NET_STREAM_PEER_CLOSED:     return "[400303] Connection closed by peer";

    default:                                                     return "Unknown error";
  }
}

#ifdef __cplusplus
}
#endif

#endif // __${app.name?upper_case}_ERROR_H__