export function timeAgo(dateString) {
  if (!dateString) return ''
  const date = new Date(dateString)
  const now = new Date()
  const diffMs = now - date
  const diffMins = Math.round(diffMs / 60000)
  
  if (diffMins < 1) return 'menos de um minuto atrás'
  if (diffMins === 1) return '1 minuto atrás'
  if (diffMins < 60) return `${diffMins} minutos atrás`
  
  const diffHours = Math.round(diffMins / 60)
  if (diffHours === 1) return 'cerca de 1 hora atrás'
  if (diffHours < 24) return `${diffHours} horas atrás`
  
  const diffDays = Math.round(diffHours / 24)
  if (diffDays === 1) return '1 dia atrás'
  if (diffDays < 30) return `${diffDays} dias atrás`
  
  const diffMonths = Math.round(diffDays / 30)
  if (diffMonths === 1) return 'cerca de 1 mês atrás'
  if (diffMonths < 12) return `${diffMonths} meses atrás`
  
  const diffYears = Math.round(diffMonths / 12)
  if (diffYears === 1) return 'cerca de 1 ano atrás'
  return `${diffYears} anos atrás`
}
