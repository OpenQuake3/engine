//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#if !defined H_id3_idtech3_config_cvar
#define H_id3_idtech3_config_cvar

#define id3_cvar_value_string_MaxLen 256

typedef enum {  // clang-format off
  id3_cvar_Archive        = 1 <<  0,  ///< Will be saved to vars.rc. For System variables, not player configurations. @reference CVAR_ARCHIVE
  id3_cvar_Info_user      = 1 <<  1,  ///< Sent to server on connect or change. @reference CVAR_USERINFO
  id3_cvar_Info_server    = 1 <<  2,  ///< Sent in response to front end requests. @reference CVAR_SERVERINFO
  id3_cvar_Info_system    = 1 <<  3,  ///< Duplicated on all clients. @reference CVAR_SYSTEMINFO
  id3_cvar_Init           = 1 <<  4,  ///< don't allow change from console at all, but can be set from the command line
  id3_cvar_Latch          = 1 <<  5,  ///< Only change when C code calls Cvar_Get(), so it can't be changed without proper initialization.
                                      ///< Modified will be set, even though the value hasn't changed yet. @reference CVAR_LATCH
  id3_cvar_ReadOnly       = 1 <<  6,  ///< Display only, cannot be set by user at all
  id3_cvar_Created_user   = 1 <<  7,  ///< Created by a set command. @reference CVAR_USER_CREATED
  id3_cvar_Temp           = 1 <<  8,  ///< Can be set even when cheats are disabled, but it is not archived. @reference CVAR_TEMP
  id3_cvar_Cheat          = 1 <<  9,  ///< Can't be changed if cheats are disabled. @reference CVAR_CHEAT
  id3_cvar_NoRestart      = 1 << 10,  ///< Do not clear when a cvar_restart is requested. @reference CVAR_NORESTART
  id3_cvar_Created_server = 1 << 11,  ///< Created by a server the client connected to. @reference CVAR_SERVER_CREATED
  id3_cvar_Created_vm     = 1 << 12,  ///< Created exclusively in one of the VMs. @reference CVAR_VM_CREATED
  id3_cvar_Protected      = 1 << 13,  ///< Prevent modifying from VMs or the server. @reference CVAR_PROTECTED
  id3_cvar_NoDefault      = 1 << 14,  ///< Do not write to config if matching with default value. @reference CVAR_NODEFAULT
  id3_cvar_Private        = 1 << 15,  ///< Can't be read from VM. @reference CVAR_PRIVATE
  id3_cvar_Developer      = 1 << 16,  ///< Can only be set in developer mode. @reference CVAR_DEVELOPER
  id3_cvar_NoTabComplete  = 1 << 17,  ///< Don't allow tab completion in console. @reference CVAR_NOTABCOMPLETE
  id3_cvar_Flag_Force32   = 0x7F'FF'FF'FF
} id3_cvar_Flag;
// clang-format on
#define id3_cvar_ArchiveND    (id3_cvar_Archive | id3_cvar_NoDefault)
#define id3_cvar_Modified     1 << 30  ///< Cvar was modified. @reference CVAR_MODIFIED
#define id3_cvar_DoesNotExist 1 << 31  ///< Cvar doesn't exist. @reference CVAR_NONEXISTENT
typedef int id3_cvar_Flags;

enum cvarValidator_e {
  id3_cvar_Any = 0,
  id3_cvar_Float,
  id3_cvar_Int,
  id3_cvar_Path,
  id3_cvar_Validator_Max,
};
typedef enum cvarValidator_e cvarValidator_t;
typedef enum cvarValidator_e id3_cvar_Type;

enum cvarGroup_e {
  id3_cvar_group_None = 0,
  id3_cvar_Renderer,
  id3_cvar_Server,
  id3_cvar_Group_Max,
};
typedef enum cvarGroup_e cvarGroup_t;
typedef enum cvarGroup_e id3_cvar_Group;

struct cvar_s {
  char*                name;
  char*                string;
  char*                resetString;        // cvar_restart will reset to this value
  char*                latchedString;      // for CVAR_LATCH vars
  int                  flags;
  bool                 modified;           // set each time the cvar is changed
  int                  modificationCount;  // incremented each time the cvar is changed
  float                value;              // Q_atof( string )
  int                  integer;            // atoi( string )
  enum cvarValidator_e type;
  char*                mins;
  char*                maxs;
  char*                description;
  struct cvar_s*       next;
  struct cvar_s*       prev;
  struct cvar_s*       hashNext;
  struct cvar_s*       hashPrev;
  int                  hashIndex;
  enum cvarGroup_e     group;  // to track changes
};
typedef struct cvar_s cvar_t;
typedef struct cvar_s id3_Cvar;

void    Cvar_Set (char const* var_name, char const* value);
cvar_t* Cvar_Get (char const* var_name, char const* value, int flags);
void    Cvar_SetDescription (cvar_t* var, char const* var_description);

#endif  // H_id3_idtech3_config_cvar

